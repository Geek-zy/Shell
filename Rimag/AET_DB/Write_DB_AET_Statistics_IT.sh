#!/bin/bash

Write_DB_and_Find() {

	DCM_IP=`cat 3_DCM_IP.Geek`
	HOSP_ID=`cat 2_HOSP_ID.Geek`

	curl http://$DCM_IP/imageList/aetSizeCount.php\?hospid=$HOSP_ID\&startdate=$Date_Start | jq . > 4_Write_DB_IT.Geek

	#count=`cat 4_Write_DB_IT.Geek | grep 'count' | awk '{print $2}' | tr -d "\"\","`
	#size=`cat 4_Write_DB_IT.Geek | grep 'size' | awk '{print $2}' | tr -d "\"\","`
	#AET=`cat 4_Write_DB_IT.Geek | grep 'AET' | awk '{print $2}' | tr -d "\"\","`
	#queryDate=`cat 4_Write_DB_IT.Geek | grep 'queryDate' | awk '{print $2}' | tr -d "\"\","`

	#echo $count
	#echo $size
	#echo $AET
	#echo $queryDate

	cat 4_Write_DB_IT.Geek | grep 'count' | awk '{print $2}' | tr -d "\"\"," > 5_Count.Geek
	cat 4_Write_DB_IT.Geek | grep 'size' | awk '{print $2}' | tr -d "\"\"," > 6_Size.Geek
	cat 4_Write_DB_IT.Geek | grep 'AET' | awk '{print $2}' | tr -d "\"\"," > 7_AET.Geek
	cat 4_Write_DB_IT.Geek | grep 'queryDate' | awk '{print $2}' | tr -d "\"\"," > 8_queryDate.Geek

	echo
	echo "----------------------------------------------------------------------------------"
	
	for ((i=1;i<=`cat 5_Count.Geek -n | awk 'END {print $1}'`;i++))
	
	  do
	
		date +%Y-%m-%d\ %H:%M:%S
		echo "Start execution ==> "
		cat 1_HOSP_IT.Geek | grep 'hospital_name' | awk '{print $2}' | tr -d "\"\","
		cat 8_queryDate.Geek | awk NR==$i
		cat 7_AET.Geek | awk NR==$i
		curl http://web.rimag.com.cn/interfaces/AetFilesize/save\?count=`cat 5_Count.Geek | awk NR==$i`\&size=`cat 6_Size.Geek | awk NR==$i`\&queryDate=`cat 8_queryDate.Geek | awk NR==$i`\&AET=`cat 7_AET.Geek | awk NR==$i`
		echo
		curl http://web.rimag.com.cn/interfaces/AetFilesize/fetch\?AET=`cat 7_AET.Geek | awk NR==$i`\&startDate=`cat 8_queryDate.Geek | awk NR==$i`\&endDate=`cat 8_queryDate.Geek | awk NR==$i`
		echo
		echo

	  done

		echo "----------------------------------------------------------------------------------"
		echo
}


Find_HOSP_ID_IT() {	

curl web.rimag.com.cn/Interfaces/index/getHospitalAetList/hospitalId/ | jq . | grep 'hospital_id'| awk '{print $2}'| tr -d "\"\"," > 0_HOSP_ID.Geek

	cat 0_HOSP_ID.Geek | while read HOSP_ID
	 
	  do

		curl web.rimag.com.cn/Interfaces/index/getHospitalAetList/hospitalId/$HOSP_ID | jq . > 1_HOSP_IT.Geek
		cat 1_HOSP_IT.Geek | grep 'hospital_id' | awk '{print $2}' | tr -d "\"\"," > 2_HOSP_ID.Geek
		cat 1_HOSP_IT.Geek | grep 'dcmip' | awk '{print $2}' | tr -d "\"\"," > 3_DCM_IP.Geek	
		Write_DB_and_Find $Date_Start
		echo $Date_Start
	  
	  done
}


Start() {

	Date_Start_Stamp=`date -d "$1" +%s`
	Date_End_Stamp=`date -d "$2" +%s`
	Date_Difference=`expr $Date_End_Stamp - $Date_Start_Stamp`
	Date_Difference=`expr $Date_Difference / 86400 + 1`
	Date_Start=`date -d@$Date_Start_Stamp +%Y-%m-%d`

	clear
	echo "----------------------------------------------------------------------------------"

	for ((i=1;i<=`expr $Date_Difference`;i++))
	  
	  do
	
		Find_HOSP_ID_IT $Date_Start 
		Date_Start=`date -d "$Date_Start -d tomorrow" +%Y-%m-%d`	
	  
	  done
}

	if [ "$1" = "" ]

	then

		clear
		echo "----------please input StartDate and EndDate-----------"
		echo "PS: [./Write_DB_AET_Statistics_IT.sh 20160501 20160505]"	
		echo "or: [./Write_DB_AET_Statistics_IT.sh \`date --date=\"-1 days\" +%Y%m%d\` \`date +%Y%m%d\`]"	

	else 

		Start $1 $2
	
	fi