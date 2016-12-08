#!/bin/bash

Geek_AI() {

HOSP_findscu_UID=/opt/dcm4che3/bin/findscu
HOSP_AET_UID=NMGHLENKYYCR:6000
HOSP_UID=ZLCRJSZJ@40.168.1.200:6000
HOSP_date_UID=20160101-`date +%Y%m%d`
HOSP_grep_UID='(0008,0020)|(0020,000D)|(0010,0020)|(0010,0010)|(0008,0061)'
HOSP_route_UID=/home/setup/Geek_zy/HOSP_UID_FILE.Geek

	clear
	echo '-------------------------------------------------------'
	echo '-------------UID ==> PID -> Name -> -------------------'
	echo '-------------------------------------------------------'

	${HOSP_findscu_UID} -b ${HOSP_AET_UID} -c ${HOSP_UID} -m StudyDate=${HOSP_date_UID} -m PatientName= -m StudyInstanceUID=$1 -m ModalitiesInStudy= -m PatientID= -m Modality= | grep -E ${HOSP_grep_UID} | awk '{print $3,$4,$5,$6}' | awk 'NR>5' 
#| tr -d "[]" ${HOSP_route_UID}

	echo '-------------------------------------------------------'
}


Start() {
	if [ "$1" =  "" ]
	then
	
	  clear
	  echo "------------------------please input UID---------------------------"
	  echo "PS:[./UID.sh 1.2.840.113619.2.252.6945.1558064.7849.1449532409.308]"
	  echo "-------------------------------------------------------------------"

	else
	  Geek_AI $1
	fi
}

Start $1
