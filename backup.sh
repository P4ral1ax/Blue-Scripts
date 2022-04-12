#!/bin/bash

# Make Secret Dir
mkdir -p /usr/share/bug/git

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



loop(){
  while [ true ]
  do
    one
    echo -ne "Backup Another? [Y/n]: " 
    read input
    case $input in
      [yY][eE][sS]|[yY])
        ;;
      [nN][oO]|[nN])
        break
        ;;
      *)
        echo "Invalid input..."
        ;;
    esac  
  done
}

loop
