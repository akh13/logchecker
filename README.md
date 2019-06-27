# logchecker
Checks a log for changes in modification time and contents. If no change occurs in X time, send an email.

## Requirements
This script uses the mailx command from the command line. This package must be installed on the target system to function correctly.

## Usage
The first step is to make sure the file to check exists. Either create the file or point the script at an existing one. This is done via the $DIRNAME and $FILENAME vars at the top of the script.

Next, once the file to check is specified, set $EMAIL and $EMAIL_SUBJ to whatever values you prefer. at default, the subject will be "Error from [hostname]".

Run the script again. You will receive a "No such file or directory" error when the initial md5sum is created from the file you are checking. This is expected.

Every subsequent check of the file will compare the mtime and the sum of the file. If neither changes in the specified amount of time, an email will be sent to the account of your choosing. Set this script to run in cron every X number of seconds.
