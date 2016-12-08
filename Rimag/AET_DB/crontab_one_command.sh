#!/bin/bash

bash Write_DB_AET_Statistics_IT.sh `date --date="-1 days" +%Y%m%d` `date +%Y%m%d` > AET_DB.log
mv ./AET_DB.log log/`date --date="-1 days" +%Y-%m-%d`.log
