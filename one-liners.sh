# List all service Binaries
find /etc/systemd/system -name "*.service" -exec cat {} + | grep ExecStart | cut -d "=" -f2  | grep -Ev "\!\!" 
find /etc/systemd/system -name "*.service" -exec cat {} + | grep -E "ExecStart|Description" | sed "s/Description/\nDescription/g" | cut -d "=" -f2 

# Find all SSH logons + time and IP

# Log each SSH login to seperate hidden file?

# Wall each Login
