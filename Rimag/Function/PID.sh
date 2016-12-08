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
	echo '-------------PID ==> UID -> Name -> -------------------'
	echo '-------------------------------------------------------'

	${HOSP_findscu_UID} -b ${HOSP_AET_UID} -c ${HOSP_UID} -m StudyDate=${HOSP_date_UID} -m PatientName= -m StudyInstanceUID= -m ModalitiesInStudy= -m PatientID=$1 -m Modality= | grep -E ${HOSP_grep_UID} | awk '{print $3,$4,$5,$6}' | awk 'NR>5' 
#| tr -d "[]" ${HOSP_route_UID}

	echo '-------------------------------------------------------'
}


Start() {
	if [ "$1" =  "" ]
	then
	
	  clear
	  echo "-------please input PID--------"
	  echo "------PS:[./PID.sh 9713]-------"
	  echo "-------------------------------"
	else
	  Geek_AI $1
	fi
}

Start $1
