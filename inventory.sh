#!/bin/bash

# OS/Kernel
echo -e "[OS]"
echo -n "OS Version     : "
cat /etc/os-release | grep "PRETTY_NAME" | grep -o "\".*.\"" | tr -d '"'
echo -n "Kernel Version : "
uname -r
echo -n "Hostname       : "
hostname

# Admin Users
echo -e "\n[Admins]"
for g in adm sudo wheel; do getent group $g; done

# Users
echo -e "\n[Users]"
getent passwd | cut -d':' -f1,3,7 | grep -Ev "nologin|false"

# IP Address/MACs
echo -ne "\n[IP]\nRoute : "
ip -c route | grep "default"
echo -e ""
ip -br -c a
echo -e "\n[MAC]"
ip -br -c link

echo -e "\n[Ports]"
ss -tulpn | grep -v "127.0.0.*"
echo ""