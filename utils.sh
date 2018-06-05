#!/bin/sh

scriptName='utils'
tmp_path='/home/netflow/git/flow-script/tmp/'
output="${tmp_path}${scriptName}.csv"
logFile="/var/www/html/log/flow.json"

logging(){
data=$(date +"%b %d %H:%M:%S")
echo "hora,script,pid,info\n"$data,$1,$2,$3 $4 > $output

str=$(csv2json $output | sed -n '2p')

sed -i "3s/$/,${str}/" $logFile
}
