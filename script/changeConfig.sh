#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Wrong number of arguments"
	exit
fi

./script/stopNodes.sh
./script/changePartition.sh $1
./script/changeClock.sh $2
echo "Partition "$1 >script/config.txt
echo "Clock "$2 >>script/config.txt
echo "Date " $(date +'%Y%m%d-%H:%M:%S') >>script/config.txt
