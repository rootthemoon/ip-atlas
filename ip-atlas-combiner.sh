#!/bin/bash
echo ""
echo "     ╦╔═╗  ╔═╗╔╦╗╦  ╔═╗╔═╗"
echo "     ║╠═╝  ╠═╣ ║ ║  ╠═╣╚═╗"
echo "     ╩╩    ╩ ╩ ╩ ╩═╝╩ ╩╚═╝"
echo ""
echo "         COMBINER ONLY"
echo " - MAC IPv4 IPv6-LL Enumerator -"
echo "           2021 v0.1"
echo ""
echo "  Requires IPv4.txt and IPv6.txt"

#Combine the two files by common field of MAC address
echo ""
echo "[+] Combining.."
echo ""
join -1 2 -2 2 -o auto -e N/A <(sort -k 2 IPv4.txt) <(sort -k 2 IPv6.txt) -a 1 -a 2 > combined.txt
sed -i '1iMAC IPv4 IPv6-LL' combined.txt
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
echo "combined.txt"
echo "atlas.csv"
