#!/bin/bash
echo ""
echo "     ╦╔═╗  ╔═╗╔╦╗╦  ╔═╗╔═╗"
echo "     ║╠═╝  ╠═╣ ║ ║  ╠═╣╚═╗"
echo "     ╩╩    ╩ ╩ ╩ ╩═╝╩ ╩╚═╝"
echo ""
echo "         HARVEST ONLY"
echo " - MAC IPv4 IPv6-LL Enumerator -"
echo "           2021 v0.2"
echo ""
echo "Usage ./ip-atlas.sh range Interface"
echo "      ./ip-atlas.sh 192.168.0.0/24 eth0"
echo ""

#check arguments have been added
[[ -z "$1" ]] && { echo "Missing network range argument" ; exit 1; }
[[ -z "$2" ]] && { echo "Missing interface argument" ; exit 1; }

# load local info into variables
sourceipv4=$(ip addr show $2 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
sourceipv6=$(ip addr show $2 | grep -oP '(?<=inet6\s)[\da-f:]+')
sourcemac=$(ip addr show $2 | awk '/ether/ {print $2}')


# nmap IPv4 IPs, sort them and add to file
echo "[+] Enumerating IPv4.."
echo ""
nmap -n -sn $1 | awk '/Nmap scan report/{printf $5;printf " ";getline;getline;print $3;}' | head -n -1 | tr A-Z a-z > IPv4.txt
echo $sourceipv4 $sourcemac >> IPv4.txt
sort -V IPv4.txt -o IPv4.txt
echo "IPv4:"
echo ""
cat IPv4.txt

#use ping6 to populate ip neigh table
echo ""
echo "[+] Enumerating IPv6.."
echo ""
ip neigh flush dev eth0
ping6 -I $2 ff02::1 -c 20 > /dev/null 2>&1
ip neighbor | cut -d " " -f 1,5 > IPv6.txt
echo $sourceipv6 $sourcemac >> IPv6.txt
sort -V IPv6.txt -o IPv6.txt
echo "IPv6:"
echo ""
cat IPv6.txt

echo ""
echo "Complete."
echo ""
echo "Files created:"
echo "IPv4.txt"
echo "IPv6.txt"
echo ""
echo "Please move the files to Kali and run ip-atlas-combiner.sh"
echo ""
