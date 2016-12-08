#!/bin/bash

   DCM_Program_Route=/home/setup/dcm4che/dcm4che-3/bin/
   DCM_twiddle_Route=/usr/local/dcm4chee/bin/
   DCM_IP=DCM4CHEE@localhost:11112
   DCM_File_Route=/home/setup/Geek_zy/NMGHLENKYYCR
   DCM_type=CR

   Geek=`${DCM_Program_Route}findscu -c $DCM_IP -m StudyDate=$1-$2 -m PatientName= -m StudyInstanceUID= -m ModalitiesInStudy=$DCM_type -m PatientID= -m Modality=$DCM_type | grep '(0020,000D)' | awk '{print $3}' |awk 'NR>1' | tr -d "[]"`

		echo -n $Geek | awk  -F " " '{for(i=1;i<=NF;i++) print $i}' >> /home/setup/Geek_zy/Journal.log
		echo "NO. ==> UID :" >> /home/setup/Geek_zy/Journal.log
		cat -n /home/setup/Geek_zy/Journal.log | awk 'END {print $1}' >> /home/setup/Geek_zy/Journal.log
		clear

	echo $Geek | awk  -F " " '{for(i=1;i<=NF;i++) print $i}' | while read Patient_UID

	   do
		date +%Y-%m-%d\ %H:%M:%S >> /home/setup/Geek_zy/Journal.log
		echo "please stand by Being executed ==> $Patient_UID" >> /home/setup/Geek_zy/Journal.log
		echo
		${DCM_Program_Route}getscu -c $DCM_IP -m StudyInstanceUID=$Patient_UID --directory $DCM_File_Route >> /home/setup/Geek_zy/Journal.log
		${DCM_twiddle_Route}twiddle.sh -u admin -p bitrms9527 invoke "dcm4chee.archive:service=ContentEditService" purgeStudy $Patient_UID >> /home/setup/Geek_zy/Journal.log
	   done

		${DCM_Program_Route}storescu -b Geek-zy -c $DCM_IP $DCM_File_Route >> /home/setup/Geek_zy/Journal.log
