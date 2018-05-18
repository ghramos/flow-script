#!/bin/sh

year=`date +%Y`
month=`date +%m`
day=`date +%d`

#ls -lt 	- List by newest first
#sed -n '2p'	- Show only line number 2
#cut -d ' ' -f9	- Get only the name of the archive

last_nfcap=`ls -lt /data/nfcap/ASA5515/$year/$month/$day/ | sed -n '2p' | cut -d ' ' -f9`

#echo  This file is being analized: $last_nfcap "\n"

nfdump -r /data/nfcap/ASA5515/$year/$month/$day/$last_nfcap -s ip/flows -o csv > tmp/output.csv

#cat tmp/output.csv

top_10=`sed -n '1,11p' tmp/output.csv | csv2json`
summary=`sed -n '14,15p' tmp/output.csv | csv2json`

echo '{ "top_10": '  $top_10  ', "summary":'  $summary  ' }' > data/output.json
