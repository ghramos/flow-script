#!/bin/sh
#. ./utils.sh

# First argument is the path of the nfcap file
scriptName='flowsHistory'
data_path='/var/www/html/data/'
tmp_path='/home/netflow/git/flow-script/tmp/'

hora=$(date +"%H:%M")

output="${tmp_path}${scriptName}.csv"
data="${data_path}${scriptName}.json"

#logging $0 $$ "Start"
echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' Start

nfdump -r $1 -s record -o csv > $output

sed -i "13s/^/hora,/" $output
sed -i "14s/^/${hora},/" $output

json=$(sed -n '13,14p' $output | csv2json | sed -n '2p')

sed -i "3s/$/,${json}/" $data

#logging $0 $$ "End"
echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' End

