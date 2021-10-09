#!/bin/bash

###########################
## Must run as superuser ##
###########################
if [ "$EUID" -ne 0 ]; then 
  echo "Must run as superuser"
  exit
fi

# Clean Up the Output of some 
# Look into Autoruns, Potetal Rootkits, Auth backdoors

sl="sleep"
s="sudo"
t="0s"

timestamp() {
  
  echo -e "\n\n-------- $(date) --------\n\n"
}

basic(){
    echo -e "\n-----------\n > Users <\n-----------"
    $s getent passwd | grep -Ev '/nologin|/false' # Use Sed to clean this up
    sleep $t

    echo -e "\n------------\n > Groups <\n------------"
    $s getent group | grep -v -E ":$"
    sleep $t

    echo -e "\n-------------\n > Sudoers <\n------------- "
    cat /etc/sudoers | grep -v -E "^#.*"
    sleep $t
    
    echo -e "\n-------------\n > Aliases <\n------------- "
    alias
    sleep $t

    echo -e "\n---------------------\n > Checking for Shims <\n---------------------"
    diff /bin/false /bin/sh
    diff /bin/false /bin/bash    
    diff /usr/sbin/nologin /bin/sh
    diff /usr/sbin/passwd /bin/passwd
    diff /usr/sbin/ls /bin/ls
    diff /usr/sbin/sudo /bin/sudo
    diff /usr/sbin/iptables /bin/iptables

    sleep $t

    echo -e "\n--------------\n > SSH Keys <\n-------------- "
    # TODO - LIST THE KEY NAMES / NUMBER OF KEYS
    $s cat /root/ssh/sshd_config | grep -i AuthorizedKeysFile
    $s cat /home/*/.ssh/authorized_keys*
    $s cat /root/.ssh/authorized_keys*
    sleep $t

    echo -e "\n-------------------------\n > Currently Logged In <\n------------------------- "
    $s who 
    sleep $t

    echo -e "\n-------------------\n > login history <\n------------------- "
    $s last | grep -Ev 'system'
    sleep $t

    echo -e "\n-------------------------------\n > Current Network Listening <\n------------------------------- "
    $s ss -tulpnw
    sleep $t

    echo -e "\n-----------------\n > lsof Remote <\n----------------- "
    $s lsof -i
    sleep $t

    echo -e "\n----------------------------\n > Potental Rootkit Signs <\n---------------------------- "
    $s dmesg | grep taint
    $s env | grep -i 'LD'
    sleep $t

    echo -e "\n-----------------------\n > Mounted Processes <\n----------------------- "
    $s mount | grep "proc"
    sleep $t

}

verbose(){
    
    echo -e "\n-------------\n > Auto Runs <\n\n------------- "
    $s cat /etc/crontab | grep -Ev '#|PATH|SHELL'
    $s cat /etc/cron.d | grep -Ev '#|PATH|SHELL'
    $s systemctl list-timers
    sleep $t

    echo -e "\n--------------\n > lsof Raw <\n-------------- "
    $s lsof | grep -i -E 'raw|pcap'
    $s lsof | grep /proc/sys/net/ipv4
    sleep $t

    echo -e "\n---------------\n > Processes <\n--------------- "
    $s ps af
    sleep $t

    echo -e "\n-------------------------\n > Poisoned Networking <\n------------------------- "
    $s cat /etc/nsswitch.conf
    $s cat /etc/hosts
    $s cat /etc/resolv.conf | grep -Ev '#|PATH|SHELL'
    $s ip netns list
    $s ip route
    sleep $t

    echo -e "\n---------------\n > Services <\n--------------- "
    $s find /etc/systemd/system -name "*.service" -exec cat {} + | grep ExecStart | cut -d "=" -f2  | grep -Ev "\!\!" 
    sleep $t

    echo -e "\n--------------------\n > Auth Backdoors <\n-------------------- "
    $s cat /etc/sudoers | grep NOPASS
    sleep $t

    echo -e "\n------------------------------\n > Files Modified Last 5Min <\n------------------------------ "
    $s find / -xdev -mmin -5 -ls &>/tmp/.ICE-linux & 
    sleep $t

    echo -e "\n------------------\n > Repositories <\n------------------ "
    $s cat /etc/apt/sources.list | grep -Ev "##|#"
    sleep $t
}

# Get User Input to get sleep time and Type
timestamp
echo -ne "Enter Option (Default : Basic)\n1) Basic Mode\n2) Verbose Mode\n\n : "
read opt
echo -n "Pause Time For Each Section (Default 0) : "
read sec

# Set Pause Time
if [[ -n $sec ]]; then
  t=${sec}s
fi

# Run User Selected Mode
if [[ $opt == 1 ]]; then 
  basic
  exit 0
else
  basic
  verbose
  exit 0
fi

## TODO ##
