#!/bin/bash

set -u
set -e
FAIL=0
Counter=0
nodes=`cat ./lisiscripts/clients`
config=`cat ./lisiscripts/config`
for node in $nodes
do
    Command1="cd ./basho_bench && sudo sed -i -e \"s/$1./\" examples/$config"
    ssh -o ConnectTimeout=10 -t ubuntu@$node -i ~/ec2-saturn ${Command1/localhost/$node} &
done
for job in `jobs -p`
do
    wait $job || let "FAIL+=1"
done
echo $Command1 done
