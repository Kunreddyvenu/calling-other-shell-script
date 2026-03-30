source ./commonvalues.sh  #we need to mention source and ./other script file
Check_Root  #it is a function we can call from commonvalues file
dnf install nginx -y &>>$LOGFILE
VALIDATE $? "instlling nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "starting the nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "removing exiting code in html file"

#we are downloading the code from below patch to /tmp/frontend.zip
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "extracting frontend code"

#check your repo and path
cp /home/ec2-user/calling-other-shell-script/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copied expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "restarting nginx"







