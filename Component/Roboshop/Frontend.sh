#!bin/bash

echo " I am Frontend User"

1. 

# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx

2. 
# curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

3. 

# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf


echo " COnfiguring Frontend"

yum install nginx -y

