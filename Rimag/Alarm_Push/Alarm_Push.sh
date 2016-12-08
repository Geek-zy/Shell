#!/bin/bash

sms_user="pkyx"
sms_passwd="bitrms123"
#phone="13920422064|15557882259|13667003438"
#phones=13811384814
sql_command="mysql -hrds5m61c4me526a7v0oyo.mysql.rds.aliyuncs.com -uclient_reader -pbitrms9527 rmsdep -e"
sql_select_all="SELECT id,d2,st1,time_s,sms,hostname FROM rmsdep.hospital_client_status"
$sql_command "$sql_select_all" --skip-column-names > /tmp/das

curl http://web.rimag.com.cn/Interfaces/index/getHospitalAetList/ | jq . | egrep "hostname|is_center" | uniq | tr -d " ,\"" | awk -F ':' '{print $2}' > /tmp/is_center

cat /tmp/das|while read line
do
	id=`echo $line|awk '{print $1}'`
	d2=`echo $line|awk '{print $2}'|tr -d '% G('` 
	st1=`echo $line|awk '{print $3}'` 
	time_s=`echo $line|awk '{print $4}'`
	sms=`echo $line|awk '{print $5}'`
	hostname=`echo $line|awk '{print $6}'` 
	new=`date +%s`
	a=`echo "$new-$time_s"|bc -l`
	
	New_hosptname=`cat /tmp/is_center | grep -B1 $hostname | awk NR==1`

	if [ $st1 != 'ok' ]
	then
		
	if [ $a -gt 7200 ]
	then

	if [ "$sms" != '1' ]
	then

	if [ "$New_hosptname" != '0' ]
	then

		hostname=`$sql_command "set names utf8;select name from hospital_client  inner join hospital  on hospital.id=hospital_client.hospital where hostname='$hostname'" --skip-column-names|awk '{print $1}'`

	if [ "$hostname" == '' ]
	then
		sql="UPDATE rmsdep.hospital_client_status SET sms ='1' WHERE id =$id"
		$sql_command "$sql"
		continue
	else
		xiaoxi="http://web.rimag.com.cn/home/Messagerest/index?content=$hostname*半个小时未与服务器通信，请您赶紧处理。"

		date>>/var/log/sms
		echo "$xiaoxi">>/var/log/sms

		curl "$xiaoxi"

	sql="UPDATE rmsdep.hospital_client_status SET sms ='1' WHERE id =$id"
	$sql_command "$sql"
fi
fi
fi
fi
fi

#-------------------------
if [ "$d2" -gt 85 ]
then

if [ "$sms" != '1' ]
then

	hostname=`$sql_command "set names utf8;select name from hospital_client  inner join hospital  on hospital.id=hospital_client.hospital where hostname='$hostname'" --skip-column-names|awk '{print $1}'`
xiaoxi="http://web.rimag.com.cn/home/Messagerest/index?content=$hostname*硬盘使用率超过80%，请您赶紧处理&phones=$iphone"
date>>/var/log/sms
echo "$xiaoxi">>/var/log/sms
curl "$xiaoxi"

sql="UPDATE rmsdep.hospital_client_status SET sms ='1' WHERE id =$id"
$sql_command "$sql"
fi

fi

done
