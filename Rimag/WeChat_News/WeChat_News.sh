#!/bin/bash


CR() {
	
	CR1=`cat log/Hosp_Equipment_type.Geek | awk -F "" '{print NF}'`
	CR2=`cat log/Hosp_Equipment_type.Geek | awk -F "CR" '{print $1}' | awk -F "" '{print NF}'`

	if [ $CR1 == $CR2 ]
		
	then
		echo "yes"
		
	else
		echo "NO"
		Mosaic=`echo ${AET_PLUS#*'CR'}`
	    echo "CR$Mosaic\t:\t" >> log/OK_Information.Geek
	fi
}


DR() {
	
	DR1=`cat log/Hosp_Equipment_type.Geek | awk -F "" '{print NF}'`
	DR2=`cat log/Hosp_Equipment_type.Geek | awk -F "DR" '{print $1}' | awk -F "" '{print NF}'`

	if [ $DR1 == $DR2 ]
		
	then
		echo "yes"
		CR $AET_PLUS
		
	else
		echo "NO"
		Mosaic=`echo ${AET_PLUS#*'DR'}`
	    echo "DR$Mosaic\t:\t" >> log/OK_Information.Geek
	fi
}


MR() {

	MR1=`cat log/Hosp_Equipment_type.Geek | awk -F "" '{print NF}'`
	MR2=`cat log/Hosp_Equipment_type.Geek | awk -F "MR" '{print $1}' | awk -F "" '{print NF}'`
	
	if [ $MR1 == $MR2 ]
		
	then
		echo "yes"
		DR $AET_PLUS
		
	else
		echo "NO"
		Mosaic=`echo ${AET_PLUS#*'MR'}`
	    echo "MR$Mosaic\t:\t" >> log/OK_Information.Geek
	fi
}


CT() {

	CT1=`cat log/Hosp_Equipment_type.Geek | awk -F "" '{print NF}'`
	CT2=`cat log/Hosp_Equipment_type.Geek | awk -F "CT" '{print $1}' | awk -F "" '{print NF}'`
		
	if [ $CT1 == $CT2 ]
		
	then
		echo "yes"
		MR $AET_PLUS
	
	else	
		echo "NO"
		Mosaic=`echo ${AET_PLUS#*'CT'}`
		echo "CT$Mosaic\t:\t" >> log/OK_Information.Geek
	fi

}


NFS_Server() {

	nfsip=`cat log/Hosp_Information.Geek | grep 'nfsip' | awk '{print $2}' | tr -d "\"\"," | awk 'NR==1'`
	hospital_name=`cat log/Hosp_Information.Geek | grep 'hospital_name' | awk '{print $2}' | tr -d "\"\","`
	
	cat log/Hosp_Information.Geek | grep 'aet' | awk '{print $2}' | tr -d "\"\"," | awk 'NR>1' > log/Hosp_AET.Geek
	echo "$hospital_name\n" >> log/OK_Information.Geek


	cat log/Hosp_AET.Geek | while read AET
         
		do
		    echo "No.==>: " " $AET"
			curl http://$nfsip/imageList/json.php\?aetitle=$AET\&startDate=$Date\&endDate=$Date | jq . | grep $AET > log/Hosp_AET_NumBer.Geek
			
			DEL=`cat log/Hosp_AET_NumBer.Geek -n | awk 'END {print $1}'`
				  
			if [ $DEL != 0 ]

			then
				echo "yes"
				echo "\t" >> log/OK_Information.Geek
				echo $AET > log/Hosp_Equipment_type.Geek
				AET_PLUS=`cat log/Hosp_Equipment_type.Geek`
				CT $AET_PLUS
				cat log/Hosp_AET_NumBer.Geek -n | awk 'END {print $1}' >> log/OK_Information.Geek
				echo "\t例\n" >> log/OK_Information.Geek
				
			else		
				echo "no"
				
			fi

		done
	
		echo "-------------------------\n" >> log/OK_Information.Geek
}


WeChat() {

	content=`cat log/OK_Information.Geek | awk '{printf $0}'`
	WeChat_News=http://web.rimag.com.cn/home/Messagerest/index

		curl $WeChat_News\?partId=$1\&content=$content\&phones=$3
}

#从文件读取医院ID，查找医院详细信息
Start() {

	Date=`date +%Y%m%d`
	Date_Geek=`date -d $Date +%Y-%m-%d`
	
	rm log/*.Geek		
	echo "$Date_Geek\n" >> log/OK_Information.Geek
	echo "-------------------------\n" >> log/OK_Information.Geek
		
	cat $2 | while read HOSP_ID
		do
			curl web.rimag.com.cn/Interfaces/index/getHospitalAetList/hospitalId/$HOSP_ID | jq . > log/Hosp_Information.Geek 
			NFS_Server
		done
}


	if [ "$1" =  "" ]

	then

		clear
		cat StanDard.Geek
	
	else 

		Start $1 $2 $3
		WeChat $1 $2 $3
	fi
