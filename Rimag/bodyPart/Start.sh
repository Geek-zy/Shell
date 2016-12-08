#!/bin/bash

log_time=`date +%Y-%m-%d\ %H:%M:%S`
log_hr="-------------------------------------------------------------"

Start() {

	if [ $Date_start == $Date_end ]
	  then
		echo "$Date_start Data ==> "
		php /home/setup/bodyPart/bodyPart.php $HOSP_ID $Date_start 
		return
	  else
		echo "$Date_start Data ==> "
		php /home/setup/bodyPart/bodyPart.php $HOSP_ID $Date_start
		Date_start=`date -d $Date_start +%s`
		Date_start=`expr $Date_start + 86400`
		Date_start=`date -d@$Date_start +%Y-%m-%d`
		Start $Date_start $Date_end
	fi
}


Date_Time() {

	Date_start=`date -d $1 +%s`
	Date_start=`date -d@$Date_start +%Y-%m-%d`

	Date_end=`date -d $2 +%s`
        Date_end=`date -d@$Date_end +%Y-%m-%d`

	Start $Date_start $2 $HOSP_ID 
}


if [ "$1" = "" ]

        then

                clear
                echo "---please input StartDate and EndDate----"
                echo "PS: [bash Start.sh 2016-07-01 2016-07-05]"  
                echo "or: [bash Start.sh 2016-07-01 2016-07-01]"  

        else
               	clear
		cat /home/setup/bodyPart/HOSP_ID.Geek | while read HOSP_ID
                  do
			echo $log_hr
			echo "Start_Time ==> $log_time"
			echo "Hosp_ID ==> $HOSP_ID"
			echo $log_hr
			Date_Time $1 $2 $HOSP_ID 
			echo "End_Time ==> $log_time" 
			echo $log_hr
			echo
			echo

                  done
fi
