#!/bin/bash

storescu=/opt/dcm4che3/bin/storescu
DCM_IP=DCM4CHEE@10.168.79.147:11112
DCM_dir=/home/setup/Geek_zy/sync/
inotifywait=/usr/bin/inotifywait
#src=/opt/sync

Read_DB() {

	$inotifywait -mrq -e moved_to $DCM_dir | while read DCM_File_Change      

           do
                redis-cli SADD sync_dcm `echo $DCM_File_Change | sed 's/ //g'`                                                                     
           done

}


DCM_File_Real_Time_Transmission() {
	
	while true

	  do

	    DCM_File_DB=`redis-cli SRANDMEMBER sync_dcm 1`	
	    AET=`echo $DCM_File_DB | awk -F "\/" '{print $6}'`
	    DCM_File=`echo $DCM_File_DB | awk -F "MOVED_TO" '{print $2}' | sed 's/ //g'`

		date +%Y-%m-%d\ %H:%M:%S
		echo "DB ==> " $DCM_File_DB 
		echo "File ==> "$DCM_File 
		echo "AET ==> "$AET	
		sleep 3
		#$storescu -b $AET -c $DCM_IP $DCM_dir$DCM_File
		redis-cli SREM sync_dcm $DCM_File_DB

	done
}


Read_DB &
DCM_File_Real_Time_Transmission
