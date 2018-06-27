#!/bin/sh
#. ./utils.sh

# First argument is the path of the nfcap file
scriptName='protoByFlows'
data_path='/var/www/html/data/'
tmp_path='/home/netflow/git/flow-script/tmp/'
log='/var/www/html/log/flow.log'

output="${tmp_path}${scriptName}.csv"
data="${data_path}${scriptName}.json"

#logging $0 $$ "Start"
echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' Start >> $log

nfdump -r $1 -s proto/flows -o csv > $output

num=$(cat $output | wc -l)

if [ $num -gt 8 ];
then
	top_10=$(sed -n '1,5p' $output | csv2json)
	summary=$(sed -n '8,9p' $output | csv2json | sed -n '2p')
else
	top_10=$(sed -n '1,4p' $output | csv2json)
        summary=$(sed -n '7,8p' $output | csv2json | sed -n '2p')
fi

echo '{ "top_10": '  $top_10  ', "summary":'  $summary  ' }' > $data

#logging $0 $$ "End"
echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' End >> $log
