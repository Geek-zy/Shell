#!/bin/bash

clear
echo "--------------------------------------------------------------------------------"
curl web.rimag.com.cn/Interfaces/index/getHospitalAetList/hospitalId/$1 | jq .
echo "--------------------------------------------------------------------------------"
echo ""
