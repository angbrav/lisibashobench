#!/bin/bash

FAIL=0
echo $command" for nodes:"$nodes 
if [ "$1" = "-nodes" ]
then
    nodes=$2
    file="$3"
    path=$4
else
    nodes=`cat ./lisiscripts/$1`
    file="$2"
    path=$3
fi

echo "Path is "$path
for node in $nodes
do
    scp -i ~/ec2-saturn $file ubuntu@$node:$path & 
done

for job in `jobs -p`
do
    wait $job || let "FAIL+=1"
done
