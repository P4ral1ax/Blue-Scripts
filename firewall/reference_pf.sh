####################################
# OpenBSD Firewall Script Refernce #
####################################

# Reference : https://srobb.net/pf.html

#!/bin/bash

###########################
## Must run as superuser ##
###########################

if [ "$EUID" -ne 0 ]
  then echo "Must run as superuser"
  exit
fi


###############
## Variables ##
###############

# Define Ports Variables
tcp_pass_in = "{ 22 80 443 }"
tcp_pass_out = "{ 22 53 }"

udp_pass_in = "{}"
udp_pass_out = "{ 53 }"

interface = "eth0"

table <bad_ips> { 192.168.8.0/24, 192.168.9.0/24, 10.23.53.123 }


#########
# Rules #
#########

# Allow Loopback Traffic
set skip on lo0 

# Default Block
block all

# Block IPs
block in quick from <bad_ips> to any

# Allow Port Ranges
pass in on $interface proto tcp to any port $tcp_pass_in
pass in on $interface proto udp to any port $udp_pass_in
pass out on $interface proto tcp to any port $tcp_pass_out
pass out on $interface proto udp to any port $udp_pass_out

# Allow Ping
pass in inet proto icmp
pass out inet proto icmp