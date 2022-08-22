#!/bin/bash

####################################################################################################################################
#
# Name: Caden Hong
#
# Date: August 18, 2022
#
# Description: This script will securely and automatically push changes to any branch but main with Git commands: ADD, COMMIT, PUSH
#	- If current user is part of the GitAcc group:
#		- If current branch is main branch, display warning message to switch branches and exit program
#		- Else:
#			- Make a directory in user's Desktop called script_result and store the location in the loc variable
#			- Store current branch in the branch variable and the corresponding remote branch in remoteBranch variable
#			- Run the "git status -s" command and store names of any file untracked or modified in filelist.txt
#			- Run the "git add ." and "git commit --queit -m 'Automatic commit using script on DATE'" command
#			- Store the following REGEX patterns for phone numbers in the phone variable:
#				- 111-111-1111
#				- (111) 111-1111
#				- 111 111 1111
#				- 1111111111
#			- Store the following REGEX pattern for social security number in the ssn variable: 111-11-1111
#			- Clear the error.txt file if it already exists, cat filelist.txt and store in Lines variable, and
#			  store the current working directory to the gitloc variable
#			- For loop go through Lines (aka filelist.txt) - for each line:
#				- Count and store the number of times the phone pattern has been identified in phone_ctr variable
#				- Count and store the number of times the SSN pattern has been identified in ssn_ctr variable
#				- If either phone_ctr or ssn_ctr is greater than 0:
#					- Store the current line (i.e. file name) and values of phone_ctr and ssn_ctr to error.txt
#			- If the error.txt file is empty (line count is 0):
#				- Run the "git push --quiet $remoteBranch" command and output confirmation message to user
#			- Else, display message that changes were not able to be pushed due to presence of sensitive information
#	- Else, display warning message that only GitAcc group can run the script and exit program
#
# Potential Issues:
#	1. The user may not want script to create a folder in their Desktop, or there may not be a Desktop folder to begin with
#	2. If script runs "git add" and "git commit" command, but fails the "git push", the next time user runs the script (after
#	   all issues are resolved), there will be outputs from git that is not able to be silenced by the script - messier terminal
#	3. There are limitations on different variations of phone number and SSN that are checked
#	4. The "git commit" message is not customizable by user - I appended the date to the commit message to reduce the number of
#	   times the user needs to interact with the script, but this limits in specifying what changes are made in each commit
#
####################################################################################################################################

if grep -q "GitAcc" <<< $(groups $USER); then
  if git branch | grep -q "* main"; then
    echo "Script cannot be run on main branch! Switch branches before running"
  else
    loc=~/Desktop/script_result
    if [ ! -d $loc ]; then
      mkdir $loc
    fi

    branch=$(git branch | grep "*" | tr -d "* ")
    remoteBranch=$(git branch -a | grep "/$branch" | awk -F/ '{print $2" "$3}')

    git status -s | grep '?? ' | sed 's/?? //' > $loc/filelist.txt
    git status -s | grep ' M ' | sed 's/ M //' >> $loc/filelist.txt

    date=$(date)
    git add .
    git commit --quiet -m "Automatic commit using script on $date"

    phone='\([0-9]\{3\}\-[0-9]\{3\}\-[0-9]\{4\}\)\|\(([0-9]\{3\})\s[0-9]\{3\}\-[0-9]\{4\}\)\|\([0-9]\{3\}\s[0-9]\{3\}\s[0-9]\{4\}\)\|\([0-9]\{10\}\)'
    ssn='[0-9]\{3\}\-[0-9]\{2\}\-[0-9]\{4\}'

    > $loc/error.txt
    Lines=$(cat $loc/filelist.txt)
    gitloc=$(pwd)

    for line in $Lines
    do
      phone_ctr=$(grep -w $phone $gitloc/$line | wc -l)
      ssn_ctr=$(grep -w $ssn $gitloc/$line | wc -l)

      if [[ $phone_ctr -gt 0 ]] || [[ $ssn_ctr -gt 0 ]]; then
        echo "$line > Detected $phone_ctr phone numbers and $ssn_ctr SSN" >> $loc/error.txt
      fi
    done

    if [ $(wc -l $loc/error.txt | awk '{print $1}') = 0 ]; then
      echo "No sensitive info detected. Pushing changes to $remoteBranch!"
      git push --quiet $remoteBranch
    else
      echo "Unable to push to $remoteBranch due to sensitive info present, exiting now..."
    fi
  fi

else
  echo "Not a member of GitAcc - you cannot run this script!"
fi
exit
