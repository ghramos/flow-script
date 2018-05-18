#!/bin/sh

year=`date +%Y`
month=`date +%m`
day=`date +%d`

#ls -lt 	- List by newest first
#sed -n '2p'	- Show only line number 2
#cut -d ' ' -f9	- Get only the name of the archive

last_nfcap=`ls -lt /data/nfcap/ASA5515/$year/$month/$day/ | sed -n '2p' | cut -d ' ' -f9`

echo $last_nfcap

