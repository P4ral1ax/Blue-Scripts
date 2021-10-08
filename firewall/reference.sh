#!/bin/bash

## May Have to mess around with firewalld ## 
    # sudo systemctl stop firewalld
    # sudo sysytemctl disable firewalld

# If this Script is not Working check .bashrc or aliases

###########################
## Must run as superuser ##
###########################

if [ "$EUID" -ne 0 ]
  then echo "Must run as superuser"
  exit
fi


################
## Main Rules ##
################

# Flush Tables 
echo "> Flushing Tables"
iptables -t mangle -F
iptables -t mangle -X
iptables -F
iptables -X

# Accept by default in case of flush
echo "> Applying Default Accept"
iptables -t mangle -P INPUT ACCEPT
iptables -t mangle -P OUTPUT ACCEPT

# Allow ICMP 
echo "> Allow ICMP"
iptables -t mangle -A INPUT -p ICMP -j ACCEPT
iptables -t mangle -A OUTPUT -p ICMP -j ACCEPT

# Allow Loopback Traffic
echo "> Allow Loopback Traffic"
iptables -t mangle -A INPUT -i lo -j ACCEPT
iptables -t mangle -A OUTPUT -o lo -j ACCEPT

# Allow Incoming SSH
echo "> Allow Inbound SSH"
iptables -t mangle -A INPUT -p tcp --dport ssh -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -t mangle -A OUTPUT -p tcp --sport ssh -m state --state ESTABLISHED -j ACCEPT


########################
# OTHER OPTIONAL RULES #
########################

# # Iptables Ranges
# iptables -t mangle -A INPUT -s 10.5.1.0/24 -j ACCEPT
# iptables -t mangle -A INPUT -s 10.5.2.0/24 -j ACCEPT
# iptables -t mangle -A INPUT -s 10.x.x.0/24 -j DENY
# iptables -t mangle -A OUTPUT -s 10.x.x.0/24 -j DENY

# # Allow HTTP Outgoing
# echo "> Allow Outbound HTTP"
# iptables -t mangle -A OUTPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -t mangle -A INPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

# # Allow HTTP Incoming
# echo "> Allow Inbound HTTP"
# iptables -t mangle -A INPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -t mangle -A OUTPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

# # Allow DNS Outgoing (UDP)
# echo "> Allow Outbound DNS (UDP)"
# iptables -t mangle -A OUTPUT -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -t mangle -A INPUT  -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

# # Allow DNS Incoming (UDP)
# echo "> Allow Inbound DNS (UDP)"
# iptables -t mangle -A INPUT -p udp --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -t mangle -A OUTPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

# # Allow SSH Outgoing
# echo "> Allow Outbound SSH"
# iptables -t mangle -A OUTPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -t mangle -A INPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# # Accept Various Port Incoming
# echo "> Allow Inbound Mayan MDMS"
# iptables -t mangle -A INPUT -p tcp --dport 8000 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -t mangle -A OUTPUT -p tcp --sport 8000 -m state --state ESTABLISHED -j ACCEPT

# # Allow Various Port Outgoing
# iptables -t mangle -A OUTPUT -p udp --dport 3000 -m state --state NEW,ESTABLISHED -j ACCEPT
# iptables -t mangle -A INPUT  -p udp --sport 3000 -m state --state ESTABLISHED -j ACCEPT


##################
## Ending Rules ##
##################

# Drop All Traffic If Not Matching
echo "> Drop non-matching traffic : Connection may drop"
iptables -t mangle -A INPUT -j DROP
iptables -t mangle -A OUTPUT -j DROP

# Backup Rules (iptables -t mangle-restore < backup)
echo "> Back up rules"
iptables-save >/etc/ip_rules

# Anti-Lockout Rule
echo "> Sleep Initiated : Cancel Program to prevent flush"
sleep 3
iptables -t mangle -F
echo "> Anti-Lockout executed : Rules have been flushed"
