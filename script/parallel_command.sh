#!/bin/bash 

set -u
set -e
FAIL=0
if [ $# -eq 1 ]
then
    nodes=`cat ./script/allnodes`
    command=$1
else
    nodes=$1
    command=$2
fi

for node in $nodes
do
	echo "command: "$command" for node: "$node
	ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -t -t root@$node -i ~/.ssh/id_rsa ${command/localhost/$node} &
done
echo "commands: "$command" done"

for job in `jobs -p`
do
    wait $job || let "FAIL+=1"
done

if [ "$FAIL" == "0" ];
then
echo "$command finished." 
else
echo "Fail! ($FAIL)"
fi
