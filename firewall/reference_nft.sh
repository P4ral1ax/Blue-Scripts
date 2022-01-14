#!/bin/bash

###############
## Variables ##
###############
SCORE_IP=10.150.72.1
RED_IP={10.150.72.2, 10.150.72.4}
nft=/usr/sbin/nft

###########
## Setup ##
###########

# Flush Existing Rules
echo "> Flushing Tables"
${nft} flush ruleset

# Create table and chains
echo "> Create Table and Chains"
${nft} add table ip mangle
${nft} add chain ip mangle INPUT "{ type filter hook input priority -150; policy accept; }"
${nft} add chain ip mangle OUTPUT "{ type route hook output priority -150; policy accept; }"


################
## Main Rules ##
################

# Allow ICMP
echo "> Allow ICMP"
${nft} add rule ip mangle INPUT ip protocol icmp counter accept
${nft} add rule ip mangle OUTPUT ip protocol icmp counter accept

# Allow Loopback
echo "> Allow Loopback Traffic"
${nft} add rule ip mangle INPUT iifname "lo" counter accept
${nft} add rule ip mangle OUTPUT oifname "lo" counter accept

# Allow Inbound SSH
echo "> Allow Inbound SSH"
${nft} add rule ip mangle INPUT tcp dport 22 ct state new,established  counter accept
${nft} add rule ip mangle OUTPUT tcp sport 22 ct state established  counter accept


########################
# OTHER OPTIONAL RULES #
########################

## IP Ranges
# ${nft} add rule ip mangle INPUT ip saddr 10.150.72.0/24 counter drop
# ${nft} add rule ip mangle INPUT ip saddr 10.2.3.4 counter drop
# ${nft} add rule ip mangle INPUT ip saddr ${SCORE_IP} counter accept
# ${nft} add rule ip mangle OUTPUT ip daddr 10.150.72.0/24 counter drop
# ${nft} add rule ip mangle OUTPUT ip daddr 10.2.3.4 counter drop
# ${nft} add rule ip mangle OUTPUT ip daddr ${SCORE_IP} counter accept

# # Allow HTTP Outgoing
# echo "> Allow Outbound HTTP"
# ${nft} add rule ip mangle OUTPUT tcp dport 80 ct state new,established  counter accept
# ${nft} add rule ip mangle INPUT tcp sport 80 ct state established  counter accept

# # Allow HTTP Incoming
# echo "> Allow Inbound HTTP"
# ${nft} add rule ip mangle INPUT tcp dport 80 ct state new,established  counter accept
# ${nft} add rule ip mangle OUTPUT tcp sport 80 ct state established  counter accept

# # Allow HTTPS Outgoing
# echo "> Allow Outbound HTTPS"
# ${nft} add rule ip mangle OUTPUT tcp dport 443 ct state new,established  counter accept
# ${nft} add rule ip mangle INPUT tcp sport 443 ct state established  counter accept

# # Allow DNS Outgoing
# echo "> Allow Outbound DNS (UDP)"
# ${nft} add rule ip mangle OUTPUT udp dport 53 ct state new,established  counter accept
# ${nft} add rule ip mangle INPUT udp sport 53 ct state established  counter accept

# # Allow DNS Incoming
# echo "> Allow Inbound DNS (UDP)"
# ${nft} add rule ip mangle INPUT udp dport 53 ct state new,established  counter accept
# ${nft} add rule ip mangle OUTPUT udp sport 53 ct state established  counter accept

# # Allow SSH Outgoing
# echo "> Allow Outbound SSH"
# ${nft} add rule ip mangle OUTPUT tcp dport 22 ct state new,established  counter accept
# ${nft} add rule ip mangle INPUT tcp sport 22 ct state established  counter accept

# # Accept Various Port Incoming
# echo "> Various Port Incoming"
# ${nft} add rule ip mangle INPUT tcp dport 8000 ct state new,established  counter accept
# ${nft} add rule ip mangle OUTPUT tcp sport 8000 ct state established  counter accept

# # Allow Various Port Outgoing
# echo "> Various Port Outgoing"
# ${nft} add rule ip mangle OUTPUT tcp dport 8000 ct state new,established  counter accept
# ${nft} add rule ip mangle INPUT tcp sport 8000 ct state estblished  counter accept 


##################
## Ending Rules ##
##################

# Default Drop all Non-Matching
${nft} add rule ip mangle INPUT counter drop
${nft} add rule ip mangle OUTPUT counter drop

# Anti-Lockout Rule
echo "> Sleep Initiated : Cancel Program to prevent flush"
sleep 3
${nft} flush ruleset
echo "> Anti-Lockout executed : Rules have been flushed"
