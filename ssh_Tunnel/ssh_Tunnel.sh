#!/bin/bash

# Key 是私钥

#ssh -Nqf -i Key -o TCPKeepAlive=yes -o ServerAliveInterval=10 -o ServerAliveCountMax=10 -o StrictHostKeyChecking=no  -o StrictHostKeyChecking=no -R 30000:localhost:22 -p7122 setup@tra.rimag.com.cn

kill -9 `ps -ef | grep "ssh -Nqf" | awk "NR==1" | awk '{printf $2}'`

sshpass -p Piece@rimag ssh -Nqf -o TCPKeepAlive=yes -o ServerAliveInterval=10 -o ServerAliveCountMax=10 -o StrictHostKeyChecking=no -R 10000:localhost:22 -p7122 setup@tra.rimag.com.cn

