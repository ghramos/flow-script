#!/bin/sh

# First argument is the path of the nfcap file
scriptName='flowByIP'
data_path='/home/netflow/git/flow-script/data/'
tmp_path='/home/netflow/git/flow-script/tmp/'

output="${tmp_path}${scriptName}.csv"
data="${data_path}${scriptName}.json"

echo '['$$']' - $scriptName start

nfdump -r $1 -s ip/flows -o csv > $output

top_10=`sed -n '1,11p' $output | csv2json`
summary=`sed -n '14,15p' $output | csv2json | sed -n '2p'`

echo '{ "top_10": '  $top_10  ', "summary":'  $summary  ' }' > $data

echo '['$$']' - $scriptName end
