#!/bin/bash

   DCM_twiddle_Route=/usr/local/dcm4chee/bin/
   DCM_IP=DCM4CHEE@localhost:11112
   DCM_type=DX

		cat -n File_UID.Geek
		echo "NO. ==> UID :"
		cat -n File_UID.Geek | awk 'END {print $1}'

	cat /home/setup/Geek_zy/Del_NMGHLENKYY_20160101_20160510/File_UID.Geek | while read Patient_UID

	   do
		date +%Y-%m-%d\ %H:%M:%S
		echo "please stand by Being executed ==> $Patient_UID"
		echo
		${DCM_twiddle_Route}twiddle.sh -u admin -p bitrms9527 invoke "dcm4chee.archive:service=ContentEditService" purgeStudy $Patient_UID

	   done

