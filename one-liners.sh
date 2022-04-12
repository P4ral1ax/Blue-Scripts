# List all service Binaries
find /etc/systemd/system -name "*.service" -exec cat {} + | grep ExecStart | cut -d "=" -f2  | grep -Ev "\!\!" 
find /etc/systemd/system -name "*.service" -exec cat {} + | grep -E "ExecStart|Description" | sed "s/Description/\nDescription/g" | cut -d "=" -f2 

# Network Monitoring
sudo tcpdump -i ens33 -v --direction=out not host 127.0.0.1 and not port 443
sudo tshark -i ens33 

# All Files Modified Last 10 Minutes
find / -xdev -mmin -10 -ls 2> /dev/null

# Check for backdoored binaries
for i in $(dpkg --get-selections | awk '{print $1}'); do sudo dpkg --verify $i; done

# Find Potential Rootkit Persistance
find /etc/init.d -exec cat {} + | grep -E 'insmod|modprobe' 2> /dev/null
find /etc/systemd/system -exec cat {} + | grep -E 'insmod|modprobe' 2> /dev/null

# Find Autoruns
find /var/spool/cron/crontabs/ -printf '\n%p\n---------------------------\n' -exec cat {} \; | grep -Ev '#'

#####################
##  AuditD Stuffs  ##
#####################

# View all event Keys Fired
cat /var/log/audit/audit.log | grep -Ev "add_rule|remove_rule" | grep -o "key=\"*.*\"" | sort | uniq -c | sort -n


# TODO
# Syslong
# https://restic.net/