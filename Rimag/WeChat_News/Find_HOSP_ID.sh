#!/bin/bash

clear
echo "--------------------------------------------------------------------------------"
curl web.rimag.com.cn/Interfaces/index/getAETList/aet/$1 | jq . |grep 'hospital_id' | tr -d "\"\","
echo "--------------------------------------------------------------------------------"
echo ""
