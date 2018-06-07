#!/bin/sh
#. ./utils.sh

# First argument is the path of the nfcap file
scriptName='ipByBytesHistoryAccumulated'
data_path='/var/www/html/data/'
tmp_path='/home/netflow/git/flow-script/tmp/'

hora=$(date +"%H:%M")

output="${tmp_path}${scriptName}.csv"
data="${data_path}${scriptName}.json"

#logging $0 $$ "Start"
echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' Start

nfdump -R $2 -s ip/bytes -o csv > $output

sed -i "14s/^/hora,/" $output
sed -i "15s/^/${hora},/" $output

summary=$(sed -n '14,15p' $output | csv2json | sed -n '2p')

sed -i "3s/$/,${summary}/" $data

#logging $0 $$ "End"
echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' End

