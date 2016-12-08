#!/bin/bash

DCM_File() {

tra3_Sync=/opt/sync/JXEFYY1CT/
dcmdump=/opt/dcm4che3/bin/dcmdump
Date=`date --date="-1 days" | awk '{print $2,$3}'`

	echo $Date
	ls -l $tra3_Sync | grep "$Date" | awk '{print $9}' > /home/setup/Geek_zy/DCM_FILE.Geek

	cat /home/setup/Geek_zy/DCM_FILE.Geek | while read DCM_FILE
	   do
		echo $DCM_FILE
		$dcmdump ${tra3_Sync}$DCM_FILE | egrep '(0020,0010)|(0010,0020)' | awk '{print $5}' | tr -d "[]" >> /home/setup/Geek_zy/JXEFYY1CT.Geek
	   done

	cat /home/setup/Geek_zy/JXEFYY1CT.Geek |sort -r | uniq -d > /home/setup/Geek_zy/2.Geek
}

DCM_Server() {

Date=`date +%s`
Date=`expr $Date - 86400`
Date=`date -d@$Date +%Y%m%d`

	curl http://nfs3.jiangxi.rimag.com.cn\/imageList\/json.php\?aetitle=JXEFYY1CT\&startDate=$Date\&endDate=$Date | jq . | egrep 'STUDY_ID|PATIENT_ID' | awk '{print $2}' | tr -d "\"\"," > /home/setup/Geek_zy/1.Geek
cat 1.Geek
}

	rm /home/setup/Geek_zy/*.Geek

	DCM_Server $1
	DCM_File

	sed '$!N;s/\n/ /g' 1.Geek
	sed '$!N;s/\n/ /g' 2.Geek 

	cat /home/setup/Geek_zy/1.Geek /home/setup/Geek_zy/2.Geek | sort -r | uniq -d > 3.Geek
