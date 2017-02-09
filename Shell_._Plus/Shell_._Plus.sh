#!/bin/bash

sum=0

while read Num
	do

		sum=`expr $sum + $Num`
	done < File.txt 

echo $sum

res=$(printf "%.2f" `echo "scale=2; $sum / 1024" | bc`)

echo "scale=2; $sum / 1024" | bc
echo $res

