#!/bin/bash

bash /home/setup/bodyPart/Start.sh `date --date="-1 days" +%Y-%m-%d` `date +%Y-%m-%d` > /home/setup/bodyPart/log/`date --date="-1 days" +%Y-%m-%d`.log
