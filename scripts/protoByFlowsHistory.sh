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

num=$(cat $output | wc -l)

sed -i "1s/^/hora,/" $output
sed -i "2s/^/${hora},/" $output
sed -i "3s/^/${hora},/" $output
sed -i "4s/^/${hora},/" $output

if [ $num -gt 8 ];
then
	sed -i "5s/^/${hora},/" $output
	icmp=$(sed -n '1,2p' $output | csv2json | sed -n '2p')
	udp=$(sed -n '1,4p' $output | sed '2,3d' | csv2json | sed -n '2p')
	tcp=$(sed -n '1,5p' $output | sed '2,4d' | csv2json | sed -n '2p')
else
        icmp=$(sed -n '1,2p' $output | csv2json | sed -n '2p')
        udp=$(sed -n '1,3p' $output | sed '2d' | csv2json | sed -n '2p')
        tcp=$(sed -n '1,4p' $output | sed '2,3d' | csv2json | sed -n '2p')
fi

sed -i "3s/$/,${tcp}/" $data
sed -i "6s/$/,${udp}/" $data
sed -i "9s/$/,${icmp}/" $data

#logging $0 $$ "End"
echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' End

