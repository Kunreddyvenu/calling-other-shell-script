<<<<<<< HEAD
#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
       echo -e "$2 ..$R Failure $N"
       exit 1 #manually exit from code 
     else
        echo -e "$2 ..$G Success $N"
        fi
}

if [ $USERID -ne 0 ]
then
   echo "please run the script with root user"
   exit 1 # manualy stop the execution and come out
else 
   echo "you are super user"
fi

=======
source ./common values.sh  #we need to mention source and ./other script file
Check_Root
>>>>>>> c03c9a8 (test)
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
cp /home/ec2-user/Venu_Shell_Project/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copied expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "restarting nginx"







