import socket
import select
import errno
import sys

HEADER_LENGTH = 10
IP = "127.0.0.1"
PORT = 1234

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((IP, PORT))
client_socket.setblocking(False)

while True:
    message = input("> ")

    if message:
        message = message.encode("utf-8")
        message_header = f"{len(message):<{HEADER_LENGTH}}".encode("utf-8")
        client_socket.send(message_header + message)

    try:
        while True:
            message_header = client_socket.recv(HEADER_LENGTH)
            if not len(message_header):
                print("Connection closed by the server")
                sys.exit()

            message_length = int(message_header.decode("utf-8").strip())
            message = client_socket.recv(message_length).decode("utf-8")

            print(message)

    except IOError as e:
        if e.errno != errno.EAGAIN and e.errno != errno.EWOULDBLOCK:
            print('Reading error', str(e))
            sys.exit()
        continue

    except Exception as e:
        print('General error', str(e))
        sys.exit()
        pass
