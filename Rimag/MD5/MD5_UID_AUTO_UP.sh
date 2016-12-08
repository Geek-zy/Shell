#!/bin/bash

MD5_UID() {

	cat /home/setup/Geek_zy/Script/MD5/CK_FILE/HOSP_UID_FILE.Geek /home/setup/Geek_zy/Script/MD5/CK_FILE/DCM_UID_FILE.Geek | sort -r | uniq -u > /home/setup/Geek_zy/Script/MD5/CK_FILE/MD5_UID_FILE.Geek

	cat /home/setup/Geek_zy/Script/MD5/CK_FILE/HOSP_UID_FILE.Geek /home/setup/Geek_zy/Script/MD5/CK_FILE/MD5_UID_FILE.Geek | sort -r | uniq -d > /home/setup/Geek_zy/Script/MD5/CK_FILE/DCM_HOSP_UID_OK.Geek
}

DCM_UID() {

DCM_findscu_UID=/opt/dcm4che3/bin/findscu
DCM_UID=DCM4CHEE@dcm.cloud.neimeng.rimag.com.cn:11112
DCM_date_UID=$1-$2
DCM_type_UID=CT
DCM_grep_UID='(0020,000D)'
DCM_route_UID=/home/setup/Geek_zy/Script/MD5/CK_FILE/DCM_UID_FILE.Geek

	${DCM_findscu_UID} -c ${DCM_UID} -m StudyDate=${DCM_date_UID} -m PatientName= -m StudyInstanceUID= -m ModalitiesInStudy=${DCM_type_UID} -m PatientID= -m Modality=${DCM_type_UID} | grep -E ${DCM_grep_UID} |awk '{print $3}' | awk 'NR>1' | tr -d "[]" > ${DCM_route_UID}
}

HOSP_UID() {

HOSP_findscu_UID=/opt/dcm4che3/bin/findscu
HOSP_AET_UID=NMGHLENKYYCR:6000
HOSP_UID=ZLCRJSZJ@40.168.1.200:6000
HOSP_date_UID=$1-$Date
HOSP_type_UID=CT
HOSP_grep_UID_1='(0008,0060)|(0008,0061)|(0010,0020)|(0020,000D)'
HOSP_grep_UID_2='CR|DR|DX|US|RF|DG|MR'
HOSP_route_UID=/home/setup/Geek_zy/Script/MD5/CK_FILE/HOSP_UID_FILE.Geek

	${HOSP_findscu_UID} -b ${HOSP_AET_UID} -c ${HOSP_UID} -m StudyDate=${HOSP_date_UID} -m PatientName= -m StudyInstanceUID= -m ModalitiesInStudy=${HOSP_type_UID} -m PatientID= -m Modality=${HOSP_type_UID} | grep -E ${HOSP_grep_UID_1} |awk '{print $3}' | awk 'ORS=NR%4?" ":"\n"{print}' | grep -Ev ${HOSP_grep_UID_2} |awk 'NR>1' | awk '{print $4}' | tr -d "[]" > ${HOSP_route_UID}
}

Get_HOSP_Pacs_UID() {

getscu_server=/opt/dcm4che3/bin/getscu
dcm_server=ZLCRJSZJ@40.168.1.200:6000
route_server=/test/wwq/NMGHLENKYYCT

	${getscu_server} -b NMGHLENKYYCR:6000 -c ${dcm_server} -m StudyInstanceUID=${uid_server} --directory ${route_server}
	date >> /home/setup/Geek_zy/Script/MD5/CK_Time/${DCM_date_UID}@Each_UID_Start_Time.time		#Geek
}



Read_UID() {

	cat /home/setup/Geek_zy/Script/MD5/CK_FILE/DCM_HOSP_UID_OK.Geek | while read uid_server #Geek
	do
	  echo "No.==>: " " $uid_server"
	  sleep 1
	  Get_HOSP_Pacs_UID
	done
}


DEl_DCM_FILE() {

	  rm -r /test/wwq/NMGHLENKYYCT
	  mkdir /test/wwq/NMGHLENKYYCT
	  chmod 777 /test/wwq/NMGHLENKYYCT
}


Geek_AI() {

	DCM_UID $1 $2
	HOSP_UID $1 $Date
	MD5_UID
#	DEl_DCM_FILE
#	Read_UID

	date > /home/setup/Geek_zy/Script/MD5/CK_Time/${DCM_date_UID}@ALL_Complete_Time.time                 #Geek
	echo "${DCM_date_UID}  ==>  Missing Date" > /home/setup/Geek_zy/Script/MD5/CK_Time/${DCM_date_UID}@Missing_Date.time

	cat -n /home/setup/Geek_zy/Script/MD5/CK_FILE/DCM_HOSP_UID_OK.Geek | awk 'END {print $1}' >> /home/setup/Geek_zy/Script/MD5/CK_Time/${DCM_date_UID}@Missing_Date.time

	clear
	  echo "---------------------------------------------------"
	  echo "--------------HOSP and DCM Date MD5 OK-------------"
	  echo "---------------------------------------------------"
	  echo "${DCM_date_UID}  ==>  DCM Missing All NUM " 
	  echo
	  cat /home/setup/Geek_zy/Script/MD5/CK_FILE/DCM_HOSP_UID_OK.Geek -n | awk 'END {print $1}'
	  
	  echo "---------------------------------------------------"
	  echo "---------------------------------------------------"
	  echo "${DCM_date_UID}  ==>  DCM Missing All Data" 
	  echo

	  cat /home/setup/Geek_zy/Script/MD5/CK_FILE/DCM_HOSP_UID_OK.Geek
	  echo "---------------------------------------------------"
	  echo
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

	Geek_AI $1 $2
}


Start() {

if [ "$1" =  "" ]
then
 	clear

	  echo "--------please input time------------"
	  echo "PS: [./MD5_UID_AUTO_UP.sh 20160101]"
	  echo "or: [./MD5_UID_AUTO_UP.sh 20160101 20160201]"
	  echo "or: [./MD5_UID_AUTO_UP.sh 20160101 \`date +%Y%m%d\`]"
	  echo 
else
	Date_Time $1 $2
fi
}

Start $1 $2
