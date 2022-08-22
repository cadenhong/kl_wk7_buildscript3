#!/bin/bash

##################################################################################
#
# Name: Caden Hong
#
# Date: August 16, 2022
#
# Description: This script will securely and automatically create a git user:
#	- Run this script and pass an argument, which will be used as username
#	- If UID is not 0, program will exit
#	- Else
#		- If passed argument exists as a username, program will exit
#		- If GitAcc group does not exist, then the group will be added
#		- sudo useradd command will be ran with GitAcc as the group name
#		  and the passed argument as the username
#	- If no argument was passed, a message will show and program will exit
#
# Potential Issues:
#	- When running the script, user may not know to use with sudo command
#	- When running the script, user may not know to pass the username argument
#	- Only users with sudo privileges will be able to run this script
#
##################################################################################

if [ $UID != 0 ]; then
  echo "You need to be a superuser to run this script!"
  exit 1
else
  if [[ -n $1 ]]; then
    if [[ $(cat /etc/passwd | awk -F: '{print $1}' | grep -x $1) ]]; then
      echo "Username $1 already exists!"
      exit
    fi
    if [[ $(getent group | awk -F: '{print $1}' | grep -x GitAcc) != "GitAcc" ]]; then
	sudo groupadd GitAcc
    fi
    sudo useradd -g GitAcc $1
    echo "New user, $1, was successfully created under the GitAcc group!"
  else
    echo "Please pass a username as argument when running this script to create a new GitAcc member!"
  fi
fi
exit
