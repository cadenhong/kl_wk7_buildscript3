# kl_wk7_buildscript3
Create a user in GitAcc group, then automatically add, commit, push changes while checking for sensitive info (i.e. phone numbers and social security numbers) using REGEX to identify patterns

## Tasks
1. Create a user and place the user into GitAcc group
2. Once a user is ready to ADD and COMMIT, run those commands for the user
3. Check files being committed for sensitive information (i.e. phone numbers and SSN) before pushing

*<p align=center>Focus on documentation, effectiveness, thoughtfulness, and error handling of the scripts</p>*

## Assumption
- The user's current working directory is already initialized as a Git repo
- There is a corresponding remote branch

## Script Flow
- See [buildscript3a.sh](https://github.com/cadenhong/kl_wk7_buildscript3/blob/main/buildscript3a.sh) for step by step description of code for creating a user in GitAcc group
- See [buildscript3b.sh](https://github.com/cadenhong/kl_wk7_buildscript3/blob/main/buildscript3b.sh) for step by step description of code for pushing changes

## Files and Folders
- [buildscript3a.sh](https://github.com/cadenhong/kl_wk7_buildscript3/blob/main/buildscript3a.sh): Script to create a user in GitAcc group
- [buildscript3b.sh](https://github.com/cadenhong/kl_wk7_buildscript3/blob/main/buildscript3b.sh): Script to automatically add, commit, and push changes to any remote branch but main
- [file.txt](https://github.com/cadenhong/kl_wk7_buildscript3/blob/main/file.txt): Test file that contains sensitive info (i.e. phone and SSN format)
