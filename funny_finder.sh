#!/bin/bash

# Find any large binary files

# sudo find / -type f -executable -size +1M -exec strings {} + | grep 'go1\.'

# Make Array
files=()

golang() {
    echo -e "\n----------\n> Golang <\n----------"
    # Put all binaries larger than 1Mb into array
    ## TAKE NOTE OF EXCLUSION
    mapfile -d $'\0' files < <(sudo find / -type f -executable -size +1M  \( ! -path '*snap*' ! -path '*container*' ! -path '*docker*' \) -print0 2>/dev/null)

    # Check each file
    for i in "${files[@]}"
    do 
        # Does it contain the go header "go1\."
        if [[ $(strings $i 2>/dev/null | grep 'go1\.' 2>/dev/null) ]]; then   
            echo "Detected GO Binary : $i"
        else
            continue
        fi
    done
}

kits() {
    echo -e "\n----------\n> Kernel <\n----------"
    # Find all files in init.d and service files
    mapfile -d $'\0' files < <(sudo find / \( -path "/etc/init.d/*" -o -path "/etc/systemd/system/*" \) -print0 2>/dev/null)

    # Find The other thing enzo showed me
    mapfile -d $'\0' files2 < <(sudo find /sys/module/ -iname "taint" -print0 2>/dev/null)

    # Check each file
    for i in "${files[@]}"
    do
        # Does this have the string "insmod" or "modprobe" print if so
        if [[ $(strings $i 2>/dev/null | grep -E 'insmod|modprobe' 2>/dev/null) ]]; then   
            echo "Detected Kernel Loading : $i"
        else
            continue
        fi
    done

    for i in "${files2[@]}"
    do
        # Does this have the signature
        if [[ $(cat $i 2>/dev/null | grep -E 'OE' 2>/dev/null) ]]; then   
            echo "Detected Tainting : $i"
        else
            continue
        fi
    done

}

echo -e "\n-------- $(date) --------\n"
echo -ne "Enter Option (Default : Basic)\n1) Golang\n2) Kernel Persistence\n3) All\n\n : "
read opt

# Run Option User Selects
if [[ $opt == 1 ]]; then 
  golang
  exit 0
fi
if [[ $opt == 2 ]]; then
  kits
  exit 0
else
  kits
  golang
  exit 0
fi