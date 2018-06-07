#!/bin/sh
#. ./utils.sh

# First argument is the path of the nfcap file
scriptName='protoByFlowsHistory'
data_path='/var/www/html/data/'
tmp_path='/home/netflow/git/flow-script/tmp/'

output="${tmp_path}${scriptName}.csv"
data="${data_path}${scriptName}.json"

hora=$(date +"%H:%M")

#logging $0 $$ "Start"
echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' Start

nfdump -r $1 -s proto -o csv > $output

tcpNum=$(grep -n 'TCP' $output | cut -c1)
udpNum=$(grep -n 'UDP' $output | cut -c1)
icmpNum=$(grep -n 'ICMP,' $output| cut -c1)

sed -i "1s/^/hora,/" $output
sed -i "2s/^/${hora},/" $output
sed -i "3s/^/${hora},/" $output
sed -i "4s/^/${hora},/" $output
sed -i "5s/^/${hora},/" $output

#sed -n "1,${tcpNum}p" $output
#sed -n "1,${udpNum}p" $output
#sed -n "1,${icmpNum}p" $output

tcp=$(sed -n "1,${tcpNum}p" $output |  csv2json | sed -n "${tcpNum}p")
udp=$(sed -n "1,${udpNum}p" $output |  csv2json | sed -n "${udpNum}p")
icmp=$(sed -n "1,${icmpNum}p" $output | csv2json | sed -n "${icmpNum}p")

#echo "TCP"$tcp"\n"
#echo "UDP"$udp"\n"
#echo "ICMP"$icmp"\n"


sed -i "3s/$/,${tcp}/" $data
sed -i "6s/$/,${udp}/" $data
sed -i "9s/$/,${icmp}/" $data

#logging $0 $$ "End"
echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' End
