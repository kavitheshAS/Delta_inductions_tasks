#!/bin/bash

sed -i "s/localhost/gemini.club/g" "/usr/local/bin/startup_script.sh"
echo "ServerName gemini.club" >> /etc/apache2/apache2.conf
apachectl -D FOREGROUND

bash /usr/local/bin/alias_incorporation.sh

#for changing order of file types in apache config file
CONFIG_FILE="/etc/apache2/mods-enabled/dir.conf"
sed -i '/^DirectoryIndex/ s/^DirectoryIndex.*/DirectoryIndex index.txt &/' "$CONFIG_FILE"
sudo systemctl restart apache2

cron -f 


