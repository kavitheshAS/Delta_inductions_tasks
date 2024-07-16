import socket
import select
import sqlite3
import hashlib
import os

PORT = 1234
HEADER_LENGTH = 10
IP = "0.0.0.0"

# Determine the path to the database file using environment variable or default path
db_path = os.getenv('DATABASE_PATH', 'users.db')

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind((IP, PORT))
server_socket.listen()

sockets_list = [server_socket]
clients = {}

# Database setup
conn = sqlite3.connect(db_path, check_same_thread=False)
cursor = conn.cursor()
cursor.execute('''CREATE TABLE IF NOT EXISTS users (username TEXT PRIMARY KEY, password TEXT)''')
cursor.execute('''CREATE TABLE IF NOT EXISTS questions (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    question TEXT,
                    options TEXT,
                    answer TEXT,
                    created_by TEXT)''')
cursor.execute('''CREATE TABLE IF NOT EXISTS leaderboard (
                    username TEXT PRIMARY KEY,
                    points INTEGER DEFAULT 0)''')
conn.commit()

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def register_user(username, password):
    hashed_password = hash_password(password)
    try:
        cursor.execute('INSERT INTO users (username, password) VALUES (?, ?)', (username, hashed_password))
        conn.commit()
        return True
    except sqlite3.IntegrityError:
        return False

def authenticate_user(username, password):
    hashed_password = hash_password(password)
    cursor.execute('SELECT * FROM users WHERE username=? AND password=?', (username, hashed_password))
    return cursor.fetchone() is not None

def add_question(question, options, answer, created_by):
    cursor.execute('INSERT INTO questions (question, options, answer, created_by) VALUES (?, ?, ?, ?)', 
                   (question, options, answer, created_by))
    conn.commit()

def answer_question(user, question_id, answer):
    cursor.execute('SELECT answer FROM questions WHERE id=?', (question_id,))
    correct_answer = cursor.fetchone()
    if correct_answer and correct_answer[0] == answer:
        cursor.execute('SELECT points FROM leaderboard WHERE username=?', (user,))
        result = cursor.fetchone()
        if result:
            points = result[0] + 1
            cursor.execute('UPDATE leaderboard SET points=? WHERE username=?', (points, user))
        else:
            cursor.execute('INSERT INTO leaderboard (username, points) VALUES (?, 1)', (user,))
        conn.commit()
        return True
    return False

def get_leaderboard():
    cursor.execute('SELECT username, points FROM leaderboard ORDER BY points DESC')
    return cursor.fetchall()

def send_message(client_socket, message):
    message = message.encode('utf-8')
    message_header = f"{len(message):<{HEADER_LENGTH}}".encode('utf-8')
    client_socket.send(message_header + message)

def receive_message(client_socket):
    try:
        message_header = client_socket.recv(HEADER_LENGTH)
        if not len(message_header):
            return False
        message_length = int(message_header.decode("utf-8").strip())
        return {"header": message_header, "data": client_socket.recv(message_length)}
    except:
        return False

while True:
    read_sockets, _, exception_sockets = select.select(sockets_list, [], sockets_list)

    for notified_socket in read_sockets:
        if notified_socket == server_socket:
            client_socket, client_address = server_socket.accept()
            user = receive_message(client_socket)
            if user is False:
                continue

            user_data = user['data'].decode('utf-8').split(' ')
            if user_data[0] == "register":
                if register_user(user_data[1], user_data[2]):
                    send_message(client_socket, "Registration successful!")
                else:
                    send_message(client_socket, "Username already exists.")
                client_socket.close()
                continue
            elif user_data[0] == "login":
                if authenticate_user(user_data[1], user_data[2]):
                    sockets_list.append(client_socket)
                    clients[client_socket] = user_data[1]
                    send_message(client_socket, "Login successful!")
                    print(f"Accepted new connection from {client_address[0]}:{client_address[1]} username: {user_data[1]}")
                else:
                    send_message(client_socket, "Invalid username or password.")
                    client_socket.close()
                continue

        else:
            message = receive_message(notified_socket)
            if message is False:
                print(f"Closed connection from {clients[notified_socket]}")
                sockets_list.remove(notified_socket)
                del clients[notified_socket]
                continue

            user = clients[notified_socket]
            message_data = message['data'].decode('utf-8').split(' ', 1)

            if message_data[0] == "add_question":
                parts = message_data[1].split(' ', 2)
                question = parts[0]
                options = parts[1]
                answer = parts[2]
                add_question(question, options, answer, user)
                send_message(notified_socket, "Question added successfully!")
            elif message_data[0] == "answer_question":
                question_id = int(message_data[1])
                answer = message_data[2]
                if answer_question(user, question_id, answer):
                    send_message(notified_socket, "Correct answer!")
                else:
                    send_message(notified_socket, "Incorrect answer.")
            elif message_data[0] == "leaderboard":
                leaderboard = get_leaderboard()
                leaderboard_str = "\n".join([f"{u}: {p}" for u, p in leaderboard])
                send_message(notified_socket, leaderboard_str)
            else:
                for client_socket in clients:
                    if client_socket != notified_socket:
                        send_message(client_socket, user + ": " + message['data'].decode('utf-8'))

    for notified_socket in exception_sockets:
        sockets_list.remove(notified_socket)
        del clients[notified_socket]
