#! /bin/bash

# Automatically remove directories created 8 days ago

flag_delete=false
fs=/dev/sda1
path=/media/admin/Backup/Backups
for file in $(ls -i /media/admin/Backup/Backups)
do
    folder=$path"/"$file
	echo $folder
	if [ $flag_delete == true ] && [ -f $folder ]
	then
		delete_file $folder
	fi
	if ! [ -f $folder ]
	then
		var=$(debugfs -R 'stat <'$file'>' $fs | grep crtime | awk '{print $5" "$6" "$7" "$8}')
		month=$(echo $var | awk '{print $1}')
		day=$(echo $var | awk '{print $2}')
	    year=$(echo $var | awk '{print $4}')
		date=$day"-"$mont"-"$year
		date_creation=$(date --date=$date +"%d-%m-%Y")
		date_reference=$(date --date="8 day ago" +"%d-%m-%Y")
		if [ "$date_creation" == "$date_reference" ]
		then
			flag_delete=true
		else
			flag_delete=false
		fi
	fi
done
