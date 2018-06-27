#!/bin/sh
#. ./utils.sh

#ls -lt         - List by newest first
#sed -n '2p'    - Show only line number 2
#cut -d ' ' -f9 - Get only the name of the archive

run_refresh() {
	year=$(date +%Y)
	month=$(date +%m)
	day=$(date +%d)
	current_nfcap=$(ls -lt /data/nfcap/ASA5515/$year/$month/$day/ | sed -n '2p' | tail -c 20)
	ret=$?
}

run_refresh
old_nfcap=""
log='/var/www/html/log/flow.log'

while true
do
	if [ ${ret} -ne 0 ];
        then
                sleep 5
		run_refresh
        fi

	if [ "$current_nfcap" != "$old_nfcap" ] && [ -n "$current_nfcap" ];
	then
#		logging $0 $$ "Start main script..."
#		logging $0 $$ "This file is being analized:" $current_nfcap
		echo $(date +"%b %d %H:%M:%S") mainProcess'['$$']:' Start main script... >> $log
		echo $(date +"%b %d %H:%M:%S") mainProcess'['$$']:' This file is being analized: $current_nfcap >> $log

		for file in scripts/*; do
			[ -f "$file" ] && [ -x "$file" ] && "$file" /data/nfcap/ASA5515/$year/$month/$day/$current_nfcap /data/nfcap/ASA5515/$year/$month/$day/
		done

#		logging $0 $$ " End main script..."
		echo $(date +"%b %d %H:%M:%S") mainProcess'['$$']:' End main script... >> $log

	fi

	sleep 5

	old_nfcap=$current_nfcap
	run_refresh
done
