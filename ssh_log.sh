#!/bin/bash

# This script will hook pam.d to log each time a new ssh login detected
# Only works if PAM Authentication is enabled...which is a Bad Idea

## Add line to /etc/pam.d/sshd
# session optional pam_exec.so /path/to/ssh_log.sh

# Get Timestamp
timestamp=$(date +"%T")

touch /var/log/sshd.log

if [ "$PAM_TYPE" != "close_session" ]; then
    host="`hostname`"
    msg= "$timestamp | $PAM_RHOST : $PAM_USER"
    echo $msg >> /var/log/sshd.log
fi