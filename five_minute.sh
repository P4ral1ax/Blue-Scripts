#!/bin/bash

## Have user select OS Type to choose function ##


###########################
## Must run as superuser ##
###########################

if [ "$EUID" -ne 0 ]
  then echo "Must run as superuser"
  exit
fi

$s = sudo 

debian() {
  # Stop Bash History Logging
  echo "> Unset HIST Files"
  unset HISTFILE
  unset PROMPT_COMMAND
  history -c 

  # Change Passwords
  echo "> Changing Passwords"
  for i in $(getent passwd | grep -v -E 'root|admin' | cut -d':' -f1); do echo -e 'password123\npassword123\n' | passwd $i; done
  history -c

  # Create Backup admin Account
  echo "> Creating Backup Account"
  $s useradd blue1 -G sudo -s /bin/bash
  $S passwd -u blue1
  history -c

  # Reinstall PAM
  echo "> Reinstalling PAM"
  $s apt-get update
  $s apt-get reinstall pam --purge

  # Install Logging
  # Snoopy
  echo "> Installing Snoopy"
  $s apt install snoopy
  $s /usr/sbin/snoopy-enable

  # pspy
  echo "> Installing pspy"
  $s apt install golang
  git clone 'https://github.com/DominicBreuker/pspy'
  go get 'github.com/dominicbreuker/pspy/cmd'
  go build /pspy 

  # Backup Possible Website
  $s 

  # Modify Firewall Rules
  sudo chmod +x /IRSEC-2021/Firewall/*

  # Reinstall Stuff
  echo '> Reinstalling Hella Stuff'
  sudo apt update
  sudo apt install --reinstall -y openssh-server lsof dnsutils coreutils net-tools procpsbuild-essential iptables tmux libpam-modules iproute2libssl-dev openssl wireshark
}

rehl(){

}

centos(){

}

debian
exit 0