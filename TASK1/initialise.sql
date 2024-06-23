CREATE DATABASE IF NOT EXISTS mydb;

USE mydb;

CREATE TABLE IF NOT EXISTS tasks(
    rollno INT  PRIMARY KEY,
    s_name VARCHAR(255) NOT NULL,
    task_no INT,
    task_status BOOLEAN,
    CHECK(task_no BETWEEN 0 AND 4) 

);

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    password VARCHAR(255),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO tasks(rollno,s_name,task_no,task_status)
VALUES ((108123055,'kavithesh',1,YES),
        (108123123,'thanu',1,YES));
