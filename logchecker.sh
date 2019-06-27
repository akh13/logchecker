#!/bin/bash

## Set specifics for API monitoring and email

DIRNAME="/var/log/"
FILENAME="logname.log"
EMAIL="root@localhost"
EMAIL_SUBJ="Error from $(hostname)"
FILECH="$DIRNAME$FILENAME"
TIMECHECK=1800 ## Time in seconds for mtime check 

## Begin logic

### If existing md5 is in /tmp, move to .1 for check sequence
  if test -f /tmp/".$FILENAME.md5sum" ; then
    ## create dummy file in tmp for md5
    rm -f /tmp/".$FILENAME.md5sum.1" 
    mv /tmp/".$FILENAME.md5sum" /tmp/".$FILENAME.md5sum.1"  
  fi

### First check if origin file actually exists
### Then exec main check
  if test -f "$FILECH"; then
    ## create dummy file in tmp for md5
     touch /tmp/".$FILENAME.md5sum"
    ## echo current md5sum into tmp file
     md5sum $FILECH | awk '{print $1}' > /tmp/.$FILENAME.md5sum
    ## Execute main check of md5sum and compare
    SUM1=$(cat /tmp/".$FILENAME.md5sum")
    SUM2=$(cat /tmp/".$FILENAME.md5sum.1")
      if [ "$SUM1" != "$SUM2" ] ; then
         exit 0
      fi
     if  [ "$SUM1" == "$SUM2" ] ; then
         echo "md5sum has not changed on logfile in $TIMECHECK seconds. Check API functionality." | \
         mailx -s "$EMAIL_SUBJ" $EMAIL
         exit 1
     fi
    ## You've checked content, now check modification time
     if [ "$(( $(date +"%s") - $(stat -c "%Y" $FILECH) ))" -gt $TIMECHECK ]; then
        echo "$FILECH is older than $TIMECHECK. Check Functionality" | \
        mailx -s "$EMAIL_SUBJ" $EMAIL
        exit 0
     fi
  else

### If file does not exist, then exit due to failure
     echo "Error! $FILECH does not exist. Exiting after notifying via email." | \
     mailx -s "$EMAIL_SUBJ" $EMAIL
     exit 1
  fi
exit 0
