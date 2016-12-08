#!/bin/bash

HOSP_UID() {

  HOSP_findscu_UID=/opt/dcm4che3/bin/findscu
  HOSP_AET_UID=NMGHLENKYYCR:6000
  HOSP_UID=ZLCRJSZJ@40.168.1.200:6000
  HOSP_date_UID=$1-$Date
  HOSP_type_UID=CR
  HOSP_grep_UID_1='(0008,0060)|(0008,0061)|(0010,0020)|(0020,000D)'
  HOSP_grep_UID_2='CT|DR|DX|US|RF|DG|MR'
  HOSP_route_UID=HOSP_UID_FILE.Geek

	${HOSP_findscu_UID} -b ${HOSP_AET_UID} -c ${HOSP_UID} -m StudyDate=${HOSP_date_UID} -m PatientName= -m StudyInstanceUID= -m ModalitiesInStudy=${HOSP_type_UID} -m PatientID= -m Modality=${HOSP_type_UID} | grep -E ${HOSP_grep_UID_1} | awk 'ORS=NR%4?" ":"\n"{print}'| awk '{print $3,$7,$11,$15}'|tr -d "[]" | awk 'NR>1'|grep -Ev ${HOSP_grep_UID_2} | awk '{print $4}'> ${HOSP_route_UID}
}


DCM_FILE_Analysis() {

  ls ./NMGHLENKYYCR > DCM_FILE.Geek
  cat DCM_FILE.Geek | while read DCM_FILE
    do
	echo "No.==>: " " $DCM_FILE"
	sleep 1
	part=`/opt/dcm4che3/bin/dcmdump ./NMGHLENKYYCR/$DCM_FILE | grep '(0018,0015)' | awk '{print $5}' | tr -d "[]"`

	if [ "$part" == "BREAST" ]
	then
        	echo $part
		mv ./NMGHLENKYYCR/$DCM_FILE ./NMGHLENKYYCR1

	elif [ "$part" == "CHEST" ]
	then
		echo $part
		mv ./NMGHLENKYYCR/$DCM_FILE ./NMGHLENKYYCR2

	elif [ "$part" == "HEAD" ]
	then
		echo $part
		mv ./NMGHLENKYYCR/$DCM_FILE ./NMGHLENKYYCR3

	else
        	echo "OTHER"
		mv ./NMGHLENKYYCR/$DCM_FILE ./NMGHLENKYYCR4
	fi

    done
}

Get_HOSP_Pacs_UID() {

  getscu_server=/opt/dcm4che3/bin/getscu
  dcm_server=ZLCRJSZJ@40.168.1.200:6000
  route_server=NMGHLENKYYCR

	${getscu_server} -b NMGHLENKYYCR:6000 -c ${dcm_server} -m StudyInstanceUID=${uid_server} --directory ${route_server}

	DCM_FILE_Analysis
}


Read_UID() {

  cat HOSP_UID_FILE.Geek | while read uid_server #Geek
  do
	echo "No.==>: " " $uid_server"
	sleep 1
	Get_HOSP_Pacs_UID
  done
}


DEl_DCM_FILE() {

          rm -r /test/wwq/NMGHLENKYYCT1 NMGHLENKYYCT2 NMGHLENKYYCT3 NMGHLENKYYCT4
          mkdir /test/wwq/NMGHLENKYYCT1 NMGHLENKYYCT2 NMGHLENKYYCT3 NMGHLENKYYCT4
          chmod 777 /test/wwq/NMGHLENKYYCT1 NMGHLENKYYCT2 NMGHLENKYYCT3 NMGHLENKYYCT4
}


Geek_AI() {

	#DEl_DCM_FILE
	HOSP_UID $1 $Date
	#Read_UID
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
	  echo "PS: [./CR_Part_DiSi.sh 20160101]"
	  echo "or: [./CR_Part_DiSi.sh 20160101 20160201]"
	  echo "or: [./CR_Part_DiSi.sh 20160101 \`date +%Y%m%d\`]"
	  echo 
else
	Date_Time $1 $2
fi
}

Start $1 $2
