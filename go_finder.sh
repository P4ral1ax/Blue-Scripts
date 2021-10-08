# Find Pesky GO files. The red teamers seem to love it. 



out = sudo find / -perm 755 -type f -size +1M

FILES=', ' read -r -a array <<< "$string"