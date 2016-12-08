#!/bin/bash

rm *.Geek

curl "http://web.rimag.com.cn/Interfaces/index/PatientCount" | jq . > Data.Geek
cat Data.Geek | grep "name" | awk '{print $2}' | tr -d "\"," > Host.Geek
cat Data.Geek | grep "count" | awk '{print $2}' | tr -d "\"" > Num.Geek

sum=0
cat Num.Geek | while read Geek 
do
	sum=`expr $sum + $Geek`
	echo -e "`date --date="-1 days" +%Y年%m月%d日`，平台登录患者总数:$sum人" > Sum.Geek
done

tac Sum.Geek | awk 'NR ==1' > OK.Geek
echo \\n\\n >> OK.Geek

i=1
cat Host.Geek | while read line
do
	Data=`cat Num.Geek | sed -n "$i"p`
	echo -e $line:$Data >> OK.Geek
	echo \\n >> OK.Geek
	i=$[$i + 1]
done

        content=`cat OK.Geek | awk '{printf $0}'`
        WeChat_News=http://web.rimag.com.cn/home/Messagerest/index

                curl $WeChat_News\?partId=13\&content=$content\&phones=13811384814
