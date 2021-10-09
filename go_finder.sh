#!/bin/bash

# Find Pesky GO files. The red teamers seem to love it. 
# Find any large binary files

# sudo find /  -type f -executable -size +1M -exec strings {} + | grep 'go1\.'

echo "Make sure strings is installed"

# Make Array
files=()

# Put all binaries larger than 1Mb into array
## TAKE NOTE OF EXCLUSION
mapfile -d $'\0' files < <(sudo find / -type f -executable -size +1M  \( ! -path '*snap*' \) -print0 2>/dev/null)

# Check each file
for i in "${files[@]}"
do
    if [[ $(strings $i 2>/dev/null | grep 'go1\.' 2>/dev/null) ]]; then   
        echo "Detected GO Binary : $i"
    else
        continue
    fi
done