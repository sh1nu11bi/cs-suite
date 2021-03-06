#!/usr/bin/env bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
BOLD='\033[1m'
YELLOW='\033[0;33m'
mkdir -p ./files && cd .. && tar czf ./lynis/files/lynis-remote.tar.gz --exclude=files/lynis-remote.tar.gz ./lynis && cd lynis
time_stamp=`date "+%Y%m%d-%H%M"`
if [ "$#" -eq 4 ];then
   printf "${YELLOW}Attempting to copy files via SCP as root user ......\n scp root@$2 i.e root@$3/root@$4 ${NC}\n"
   scp=`scp -o "StrictHostKeyChecking no" -q ./files/lynis-remote.tar.gz root@$2:~/tmp-lynis-remote.tgz`
   status=$?
   if [ $status -eq 0 ];then
       printf "${GREEN}Lynis file copied over the server${NC}\n"
       printf "${YELLOW}Attempting to SSH the server..... \n ssh root@$2 i.e root@$3/root@$4 ${NC}\n" 
       audit=`ssh -o "StrictHostKeyChecking no" root@$2 "mkdir -p ~/tmp-lynis && cd ~/tmp-lynis && tar xzf ../tmp-lynis-remote.tgz && rm ../tmp-lynis-remote.tgz && chown -R 0:0 lynis && cd lynis && ./lynis audit system"`
       status=$?
       if [ $status -eq 0 ];then
           printf "${GREEN}Lynis Audit Done${NC}\n"
           mkdir -p ../../reports/local_audit/$1/$3-$4
           echo "$audit" |  ansi2html > ../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html
           printf "${GREEN}Cleaning up files${NC}\n"
           clean=`ssh $2 "rm -rf ~/tmp-lynis"`
           #cat ../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp | ansi2html > ../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html
           printf "${BOLD} Report ------> reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html${NC}\n"
           open "../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html"
       else
           printf "${RED}Not able SSH the server...please try using help 'python cs.py -h'${NC}\n"
       fi
   else
       printf "${RED}Not able to SCP please try using help 'python cs.py -h'${NC}\n"
   fi
   
elif [[ -z "$6" && -z "$7" ]];then
   printf "${YELLOW}Attempting to copy files via SCP  ......\n scp $5@$2 i.e $5@$3/$5@$4 ${NC}\n"
   scp=`scp -o "StrictHostKeyChecking no" -q ./files/lynis-remote.tar.gz $5@$2:~/tmp-lynis-remote.tgz`
   status=$?
   if [ $status -eq 0 ];then
       printf "${GREEN}Lynis file copied over the server${NC}\n"
       printf "${YELLOW}Attempting to SSH the server..... \n ssh $5@$2  ${NC}\n"
       audit=`ssh -o "StrictHostKeyChecking no" $5@$2 "mkdir -p ~/tmp-lynis && cd ~/tmp-lynis && tar xzf ../tmp-lynis-remote.tgz && rm ../tmp-lynis-remote.tgz && cd lynis && chmod 640 include/* && ./lynis audit system 2>/dev/null"`
       status=$?
       if [ $status -eq 0 ];then
           printf "${GREEN}Lynis Audit Done${NC}\n"
           mkdir -p ../../reports/local_audit/$1/$3-$4
           echo "$audit" |  ansi2html > ../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html
           printf "${GREEN}Cleaning up files${NC}\n"
           clean=`ssh $5@$2 "rm -rf ~/tmp-lynis"`
           printf "${BOLD} Report ------> reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html${NC}\n"
           open "../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html"
       else
           printf "${RED}Not able SSH the server...please try using help 'python cs.py -h'${NC}\n"
       fi
   else
       printf "${RED}Not able to SCP please try using help 'python cs.py -h'${NC}\n"
   fi

elif [[ -z "$5" && -z "$7" ]];then
   printf "${YELLOW}Attempting to copy files via SCP  ......\n scp -i $6 ec2-user@$2 i.e ec2-user@$3/ec2-user@$4 ${NC}\n"
   scp=`scp -i $6 -o "StrictHostKeyChecking no" -q ./files/lynis-remote.tar.gz ec2-user@$2:~/tmp-lynis-remote.tgz`
   status=$?
   if [ $status -eq 0 ];then
       printf "${GREEN}Lynis file copied over the server${NC}\n"
       printf "${YELLOW}Attempting to SSH the server..... \n ssh -i $6 ec2-user@$2  ${NC}\n"
       audit=`ssh -i $6 -o 'StrictHostKeyChecking no' ec2-user@$2 'mkdir -p ~/tmp-lynis && cd ~/tmp-lynis && tar xzf ../tmp-lynis-remote.tgz && rm ../tmp-lynis-remote.tgz && cd lynis && chmod 640 include/* && ./lynis audit system 2>/dev/null'`
       status=$?
       if [ $status -eq 0 ];then
           printf "${GREEN}Lynis Audit Done${NC}\n"
           mkdir -p ../../reports/local_audit/$1/$3-$4
           echo "$audit" |  ansi2html > ../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html
           printf "${GREEN}Cleaning up files${NC}\n"
           clean=`ssh -i $6 ec2-user@$2 "rm -rf ~/tmp-lynis"`
           printf "${BOLD} Report ------> reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html${NC}\n"
           open "../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html"
       else
           printf "${RED}Not able SSH the server with user ec2-user... try using help 'python cs.py -h'${NC}\n"
       fi
   else
       printf "${RED}Not able to SCP please try using help 'python cs.py -h'${NC}\n"
   fi

elif [[ -z "$5" && -z "$6" ]];then
   printf "${YELLOW}Attempting to copy files via SCP  ......\n sshpass -p "password" scp root@$2 i.e root @$3/root@$4 ${NC}\n"
   scp=`sshpass -p $7 scp -o "StrictHostKeyChecking no" -q ./files/lynis-remote.tar.gz root@$2:~/tmp-lynis-remote.tgz`
   status=$?
   if [ $status -eq 0 ];then
       printf "${GREEN}Lynis file copied over the server${NC}\n"
       printf "${YELLOW}Attempting to SSH the server..... \n sshpass -p password ssh root@$2 ${NC}\n"
       audit=`sshpass -p $7 ssh -o 'StrictHostKeyChecking no' root@$2 'mkdir -p ~/tmp-lynis && cd ~/tmp-lynis && tar xzf ../tmp-lynis-remote.tgz && rm ../tmp-lynis-remote.tgz && chown -R 0:0 lynis && cd lynis && ./lynis audit system 2>/dev/null'`
       status=$?
       if [ $status -eq 0 ];then
           printf "${GREEN}Lynis Audit Done${NC}\n"
           mkdir -p ../../reports/local_audit/$1/$3-$4
           echo "$audit" |  ansi2html > ../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html
           printf "${GREEN}Cleaning up files${NC}\n"
           clean=`sshpass -p $7 ssh root@$2 "rm -rf ~/tmp-lynis"`
           printf "${BOLD} Report ------> reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html${NC}\n"
           open "../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html"
       else
           printf "${RED}Not able SSH the server...please try using help 'python cs.py -h'${NC}\n"
       fi
   else
       printf "${RED}Not able to SCP please try using help 'python cs.py -h'${NC}\n"
   fi

elif [ -z "$6" ];then
   printf "${YELLOW}Attempting to copy files via SCP  ......\n sshpass -p "password" scp $5$2 i.e $5@$3/$5@$4 ${NC}\n"
   scp=`sshpass -p $7 scp -o "StrictHostKeyChecking no" -q ./files/lynis-remote.tar.gz $5@$2:~/tmp-lynis-remote.tgz`
   status=$?
   if [ $status -eq 0 ];then
       printf "${GREEN}Lynis file copied over the server${NC}\n"
       printf "${YELLOW}Attempting to SSH the server..... \n sshpass -p password ssh $5@$2 ${NC}\n"
       audit=`sshpass -p $7 ssh -o 'StrictHostKeyChecking no' $5@$2 'mkdir -p ~/tmp-lynis && cd ~/tmp-lynis && tar xzf ../tmp-lynis-remote.tgz && rm ../tmp-lynis-remote.tgz && cd lynis && chmod 640 include/* && ./lynis audit system 2>/dev/null'`
       status=$?
       if [ $status -eq 0 ];then
           printf "${GREEN}Lynis Audit Done${NC}\n"
           mkdir -p ../../reports/local_audit/$1/$3-$4
           echo "$audit" |  ansi2html > ../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html
           printf "${GREEN}Cleaning up files${NC}\n"
           clean=`sshpass -p $7 ssh $5@$2 "rm -rf ~/tmp-lynis"`
           printf "${BOLD} Report ------> reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html${NC}\n"
           open "../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html"
       else
           printf "${RED}Not able SSH the server...please try using help 'python cs.py -h'${NC}\n"
       fi
   else
       printf "${RED}Not able to SCP please try using help 'python cs.py -h'${NC}\n"
   fi

elif [ -z "$7" ];then
   printf "${YELLOW}Attempting to copy files via SCP  ......\n scp -i $6 $5@$2 i.e $5@$3/$5@$4 ${NC}\n"
   scp=`scp -i $6 -o "StrictHostKeyChecking no" -q ./files/lynis-remote.tar.gz $5@$2:~/tmp-lynis-remote.tgz`
   status=$?
   if [ $status -eq 0 ];then
       printf "${GREEN}Lynis file copied over the server${NC}\n"
       printf "${YELLOW}Attempting to SSH the server..... \n ssh -i $6 $5@$2  ${NC}\n"
       audit=`ssh -i $6 -o 'StrictHostKeyChecking no' $5@$2 'mkdir -p ~/tmp-lynis && cd ~/tmp-lynis && tar xzf ../tmp-lynis-remote.tgz && rm ../tmp-lynis-remote.tgz && cd lynis && chmod 640 include/* && ./lynis audit system 2>/dev/null'`
       status=$?
       if [ $status -eq 0 ];then
           printf "${GREEN}Lynis Audit Done${NC}\n"
           mkdir -p ../../reports/local_audit/$1/$3-$4
           echo "$audit" |  ansi2html > ../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html
           printf "${GREEN}Cleaning up files${NC}\n"
           clean=`ssh -i $6 $5@$2 "rm -rf ~/tmp-lynis"`
           printf "${BOLD} Report ------> reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html${NC}\n"
           open "../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html"
       else
           printf "${RED}Not able SSH the server with user ec2-user... try using help 'python cs.py -h'${NC}\n"
       fi
   else
       printf "${RED}Not able to SCP please try using help 'python cs.py -h'${NC}\n"
   fi

elif [ -z "$5" ];then
   printf "${YELLOW}Attempting to copy files via SCP  ......\n sshpass -p "password" scp -i $6 ec2-user@$2 i.e ec2-user@$3/ec2-user@$4 ${NC}\n"
   scp=`sshpass -p $7 scp -i $6 -o "StrictHostKeyChecking no" -q ./files/lynis-remote.tar.gz ec2-user@$2:~/tmp-lynis-remote.tgz`
   status=$?
   if [ $status -eq 0 ];then
       printf "${GREEN}Lynis file copied over the server${NC}\n"
       printf "${YELLOW}Attempting to SSH the server..... \n sshpass -p password ssh -i $6 ec2-user@$2  ${NC}\n"
       audit=`sshpass -p password ssh -i $6 -o "StrictHostKeyChecking no" ec2-user@$2 "mkdir -p ~/tmp-lynis && cd ~/tmp-lynis && tar xzf ../tmp-lynis-remote.tgz && rm ../tmp-lynis-remote.tgz && cd lynis && chmod 640 include/* && ./lynis audit system 2>/dev/null"`
       status=$?
       if [ $status -eq 0 ];then
           printf "${GREEN}Lynis Audit Done${NC}\n"
           mkdir -p ../../reports/local_audit/$1/$3-$4
           echo "$audit" |  ansi2html > ../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html
           printf "${GREEN}Cleaning up files${NC}\n"
           clean=`sshpass -p $7 ssh -i $6 ec2-user@$2 "rm -rf ~/tmp-lynis"`
           printf "${BOLD} Report ------> reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html${NC}\n"
           open "../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html"
       else
           printf "${RED}Not able SSH the server with user ec2-user... try using help 'python cs.py -h'${NC}\n"
       fi
   else
       printf "${RED}Not able to SCP please try using help 'python cs.py -h'${NC}\n"
   fi
else
   printf "${YELLOW}Attempting to copy files via SCP  ......\n sshpass -p "password" scp -i $6 $5@$2 i.e $5@$3/$5@$4 ${NC}\n"
   scp=`sshpass -p $7 scp -i $6 -o "StrictHostKeyChecking no" -q ./files/lynis-remote.tar.gz $5@$2:~/tmp-lynis-remote.tgz`
   status=$?
   if [ $status -eq 0 ];then
       printf "${GREEN}Lynis file copied over the server${NC}\n"
       printf "${YELLOW}Attempting to SSH the server..... \n sshpass -p password ssh -i $6 $5@$2  ${NC}\n"
       audit=`sshpass -p password ssh -i $6 -o "StrictHostKeyChecking no" $5@$2 "mkdir -p ~/tmp-lynis && cd ~/tmp-lynis && tar xzf ../tmp-lynis-remote.tgz && rm ../tmp-lynis-remote.tgz && cd lynis && chmod 640 include/* && ./lynis audit system 2>/dev/null"`
       status=$?
       if [ $status -eq 0 ];then
           printf "${GREEN}Lynis Audit Done${NC}\n"
           mkdir -p ../../reports/local_audit/$1/$3-$4
           echo "$audit" |  ansi2html > ../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html
           printf "${GREEN}Cleaning up files${NC}\n"
           clean=`sshpass -p $7 ssh -i $6 $5@$2 "rm -rf ~/tmp-lynis"`
           printf "${BOLD} Report ------> reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html${NC}\n"
           open "../../reports/local_audit/$1/$3-$4/lynis.report_$time_stamp.html"
       else
           printf "${RED}Not able SSH the server with user ec2-user... try using help 'python cs.py -h'${NC}\n"
       fi
   else
       printf "${RED}Not able to SCP please try using help 'python cs.py -h'${NC}\n"
   fi     

fi         
