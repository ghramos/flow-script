#!/bin/sh

# First argument is the path of the nfcap file
scriptName='protoByBytes'
data_path='/home/netflow/git/flow-script/data/'
tmp_path='/home/netflow/git/flow-script/tmp/'

output="${tmp_path}${scriptName}.csv"
data="${data_path}${scriptName}.json"

echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' Start

nfdump -r $1 -s proto/bytes -o csv > $output

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

echo $(date +"%b %d %H:%M:%S") $scriptName'['$$']:' End
