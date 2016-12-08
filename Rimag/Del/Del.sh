#!/bin/bash 

dcm4chee=/home/setup/dcm4che/bin/
DCM_IP=DCM4CHEE@localhost:11112

${dcm4chee}findscu -c $DCM_IP -m StudyDate= -m PatientName= -m StudyInstanceUID= -m ModalitiesInStudy= -m PatientID= -m Modality= | grep '0020,000D' | awk '{print $3}' | tr -d "[]" | awk 'NR>1' > DCM_UID.Geek


cat DCM_UID.Geek | while read DCM_UID
do
echo $DCM_UID
/usr/local/dcm4chee/bin/twiddle.sh -u admin -p bitrms9527 invoke "dcm4chee.archive:service=ContentEditService" purgeStudy $DCM_UID
done
