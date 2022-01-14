# List all service Binaries
find /etc/systemd/system -name "*.service" -exec cat {} + | grep ExecStart | cut -d "=" -f2  | grep -Ev "\!\!" 
find /etc/systemd/system -name "*.service" -exec cat {} + | grep -E "ExecStart|Description" | sed "s/Description/\nDescription/g" | cut -d "=" -f2 

# Network Monitoring
sudo tcpdump -i ens33 -v --direction=out not host 127.0.0.1 and not port 443
sudo tshark -i ens33 

# All Files Modified
find / -xdev -mmin -10 -ls 2> /dev/null

