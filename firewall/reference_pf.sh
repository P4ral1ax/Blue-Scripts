####################################
# OpenBSD Firewall Script Refernce #
####################################

#!/bin/bash

###########################
## Must run as superuser ##
###########################

if [ "$EUID" -ne 0 ]
  then echo "Must run as superuser"
  exit
fi

#########
# Rules #
#########

# Allow Loopback Traffic
set skip on lo0 

# Default Block
block all

# Allow SSH/HTTP/DNS
pass in proto tcp to port { 22 80 }
pass in proto udp to port { 53 }
pass out proto { tcp udp } to port { 22 53 80 }

# Allow Ping
pass in inet proto icmp
pass out inet proto icmp



