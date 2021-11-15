#!/bin/bash
echo ""
echo "     ╦╔═╗  ╔═╗╔╦╗╦  ╔═╗╔═╗"
echo "     ║╠═╝  ╠═╣ ║ ║  ╠═╣╚═╗"
echo "     ╩╩    ╩ ╩ ╩ ╩═╝╩ ╩╚═╝"
echo ""
echo " - MAC IPv4 IPv6-LL Enumerator -"
echo "           2021 v0.1"
echo ""
echo "Usage ./ip-atlas.sh range Interface"
echo "      ./ip-atlas.sh 192.168.0.0/24 eth0"
echo ""

#check arguments have been added
[[ -z "$1" ]] && { echo "Missing network range argument" ; exit 1; }
[[ -z "$2" ]] && { echo "Missing interface argument" ; exit 1; }

# nmap IPv4 IPs, sort them and add to file
echo "[+] Enumerating IPv4.."
echo ""
nmap -n -sn $1 | awk '/Nmap scan report/{printf $5;printf " ";getline;getline;print $3;}' | head -n -1 | sort -V | tr A-Z a-z > IPv4.txt
echo "IPv4:"
echo ""
cat IPv4.txt

#use ping6 to populate ip neigh table
echo ""
echo "[+] Enumerating IPv6.."
echo ""
ip neigh flush dev eth0
ping6 -I $2 ff02::1 -c 20 > /dev/null 2>&1
ip neighbor | cut -d " " -f 1,5 | sort -V > IPv6.txt
echo "IPv6:"
echo ""
cat IPv6.txt

#Combine the two files by common field of MAC address
echo ""
echo "[+] Combining.."
echo ""
join -1 2 -2 2 -o auto -e N/A <(sort -k 2 IPv4.txt) <(sort -k 2 IPv6.txt) -a 1 -a 2 > combined.txt
echo "Combined:"
echo ""
cat combined.txt
echo ""

# Sort for CSV and create CSV
echo "[+] Modifying and printing to CSV.."
echo ""
echo "Modified:"
echo ""
cat combined.txt | tr -s '[:blank:]' ',' | tee atlas.csv
echo ""
echo "Complete."
echo ""

echo "Files created:"
echo "IPv4.txt"
echo "IPv6.txt"
echo "combined.txt"
echo "atlas.csv"
