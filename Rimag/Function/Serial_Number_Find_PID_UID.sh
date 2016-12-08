#!/bin/bash

HOSP_UID() {

  HOSP_findscu_UID=/opt/dcm4che3/bin/findscu
  HOSP_AET_UID=NMGHLENKYYCR:6000
  HOSP_UID=ZLCRJSZJ@40.168.1.200:6000
  HOSP_date_UID=$1-$Date
  HOSP_type_UID=CT
  HOSP_grep_UID_1='(0008,0060)|(0008,0061)|(0010,0020)|(0020,000D)'
  HOSP_grep_UID_2='CR|DR|DX|US|RF|DG|MR'
  HOSP_route_UID=HOSP_UID_FILE.Geek

	${HOSP_findscu_UID} -b ${HOSP_AET_UID} -c ${HOSP_UID} -m StudyDate=${HOSP_date_UID} -m PatientName= -m StudyInstanceUID= -m ModalitiesInStudy=${HOSP_type_UID} -m PatientID= -m Modality=${HOSP_type_UID} | grep -E ${HOSP_grep_UID_1} |awk '{print $3}' | awk 'ORS=NR%4?" ":"\n"{print}' | grep -Ev ${HOSP_grep_UID_2} |awk 'NR>1' | awk '{print $4}' | tr -d "[]" > ${HOSP_route_UID}
}


Core_Code() {

   ls -ltr NMGHLENKYYCT | tail -n 1 | awk '{print $9}' > Temporary_Lookup_FILE.Geek
   data=`cat Temporary_Lookup_FILE.Geek`
   Serial_Number=`/opt/dcm4che3/bin/dcmdump NMGHLENKYYCT/$data | grep '(0020,0010)' | awk '{print $5}' | tr -d "[]"`

   if [ "$3" = "$Serial_Number" ]
   then
	clear
	echo "yes"
	/opt/dcm4che3/bin/dcmdump NMGHLENKYYCT/$data > Find_FILE_OK.Geek
	cat Find_FILE_OK.Geek | grep -E '(0008,0020)|(0020,000D)|(0010,0020)|(0010,0010)|(0008,0061)|(0020,0010)' | awk '{print $5,$6,$7,$8,$9}' > Find_PID_OK.Geek
	clear
	cat Find_PID_OK.Geek
	exit  
   else
	clear
	echo "no"
   fi
}


Get_HOSP_Pacs_UID() {

  getscu_server=/opt/dcm4che3/bin/getscu
  dcm_server=ZLCRJSZJ@40.168.1.200:6000
  route_server=NMGHLENKYYCT

	${getscu_server} -b NMGHLENKYYCR:6000 -c ${dcm_server} -m StudyInstanceUID=${uid_server} --directory ${route_server}
 	Core_Code $1 $2 $3
}


DEl_DCM_FILE() {

	  rm -r NMGHLENKYYCT
	  mkdir NMGHLENKYYCT
	  chmod 777 NMGHLENKYYCT
}


Read_UID() {

	cat HOSP_UID_FILE.Geek | while read uid_server
	do
	  echo "No.==>: " " $uid_server"
	  sleep 1
	  DEl_DCM_FILE
	  Get_HOSP_Pacs_UID $1 $2 $3
	done
}


Geek_AI() {

	#HOSP_UID $1 $Date
	#DEl_DCM_FILE
	Read_UID $1 $2 $3
}


Date_Time() {

	if [ "$2" =  "" ]
	then
	  Date=`date -d "$1" +%s`
	  Date=`expr $Date + 86400`
	  Date=`date -d@$Date +%Y%m%d`
	else
	  Date=`date -d "$2" +%s`
	  Date=`expr $Date + 86400`
	  Date=`date -d@$Date +%Y%m%d`
	fi

	Geek_AI $1 $2 $3
}


Start() {

if [ "$1" =  "" ]
then
 	clear

	  echo "---------------------please input time-------------------------------"
	  echo "PS: [Serial_Number_Find_PID_UID.sh 20160101 20160201 32536]"
	  echo "or: [Serial_Number_Find_PID_UID.sh 20160101 \`date +%Y%m%d\` 32536]"
	  echo 
else
	Date_Time $1 $2 $3
fi
}

Start $1 $2 $3
