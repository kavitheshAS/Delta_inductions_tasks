
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && \
    apt-get install -y apache2 php libapache2-mod-php php-mysql nano sed cron && \
    apt-get clean  

COPY TASK1/userGen.sh /usr/local/bin/
COPY TASK1/domainPref.sh /usr/local/bin/
COPY TASK1/mentorAllocation.sh /usr/local/bin/
COPY TASK1/submitTask.sh /usr/local/bin/
COPY TASK1/displayStatus.sh /usr/local/bin/
COPY TASK1/deRegister.sh /usr/local/bin/
COPY TASK1/cronjob.sh /usr/local/bin/
COPY TASK1/clean_mentee.sh /usr/local/bin/
COPY TASK1/setQuiz.sh /usr/local/bin/
COPY TASK1/mentees_domain.txt /var/www/html/
COPY php_Code/* /var/www/html
COPY TASK1/alias_incorporation.sh /usr/local/bin/


RUN chmod -R +x /usr/local/bin
RUN chmod -R +x /var/www/html

#COPY TASK1/phpsql.php /var/www/html/


EXPOSE 80


COPY TASK1/startup_script.sh /usr/local/bin/startup_script.sh
RUN chmod +x /usr/local/bin/startup_script.sh


# Start container with the startup script
CMD ["/usr/local/bin/startup_script.sh"]


