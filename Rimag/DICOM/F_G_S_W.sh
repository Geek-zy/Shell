#!/bin/bash 

#dcm4chee=/home/setup/dcm4che/bin/
dcm4chee=/home/setup/dcm4chee/dcm4che/dcm4che3/bin/
DCM_IP=DCM4CHEE@dcm.cloud.neimeng.rimag.com.cn:11112
DCM_type=MR
DCM_date=$1-$2
DCM_UID=$3
Dir=/home/setup/Geek_zy/date
AET=Geek_AET
Pacs_U=admin
Pacs_P=bitrms9527

findscu() {

	${dcm4chee}findscu -c $DCM_IP -m StudyDate=$DCM_date -m PatientName= -m StudyInstanceUID= -m ModalitiesInStudy=$DCM_type -m PatientID= -m Modality=$DCM_type
}


getscu() {

	${dcm4chee}getscu -c $DCM_IP -m StudyInstanceUID=$DCM_UID --Directory $Dir
}


storescu() {

	${dcm4chee}storescu -b $AET -c $DCM_IP $Dir
}


twiddle() {

	${dcm4chee}twiddle.sh -u $Pacs_U -p $Pacs_P invoke "dcm4chee.archive:service=ContentEditService" purgeStudy $DCM_UID
}

getscu
