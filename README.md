# Delta_inductions_tasks

To streamline the induction management server setup, you are required to automate it with the help of docker.

Normal Mode
Dockerise Task 1
You need to dockerise the server setup done in task 1.
Using an appropriate base image (eg. Ubuntu), copy all the scripts to the appropriate locations and run them accordingly.

Display the domain file
In Task 1, Core has a mentees_domain.txt file in their home dir containing the roll number and domains. We want to be able to view that file.
  
Display the file using Apache from the local directory of the docker container. Proxy the requests to the container.

Make the file accessible locally using gemini.club instead of default localhost. Opening gemini.club should display the text file directly.

Store user details in Database
Create a database to store all the task details instead of the files in the mentee's directory.
Use only MySQL or PostgreSQL. SQLite is not allowed. You may use any programming language to do the above. Use raw SQL queries to do this, do not use ORMs (eg. SQLAlchemy).
Dockerise the database along with the server. Use docker-compose.


SuperUser Mode


Setup a cronjob to periodically take database backup. The backup should take place at 3 minutes past every hour from 5am through 8am and also including 3pm on the 1st day of the month, and if it's on every 2nd day-of-week in every month from January through July. Do not setup multiple cronjobs.

Modify the docker setup to ensure that restarting docker will not destroy the data from database.

Add PHPMyAdmin docker service for viewing the database. Also create an account in PHPMyAdmin with read-only permissions to read the user details in the DB.
Create a website to display the user details based on their permissions (similar to those in task 1). You can use PHP, Node.JS-Express or Flask to create the backend. You are not allowed to use frameworks like Django or Laravel.

Implement login feature with userid and password. Get the permissions based on the logged in userid.
Core should be able to see everyone's details.
Mentors should be able to see only their mentee's details.
Mentees should only be able to see their own details.

    Note: You need not focus too much on the design of the website. It can be made with simple HTML and CSS. You are allowed to use Bootstrap if you do not wish to write CSS.
