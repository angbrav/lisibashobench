#!/bin/bash

set -u
set -e
FAIL=0
Counter=0
nodes=`cat ./lisiscripts/clients`
for node in $nodes
do
    let Counter=Counter+1
    NodeName="basho_bench$Counter@$node"
    Command2="erl -pa script -name $NodeName -setcookie antidote -run init stop"
    ssh -o ConnectTimeout=10 -t ubuntu@$node -i ~/ec2-saturn ${Command2/localhost/$node} &
done
echo $Command2 done

for job in `jobs -p`
do
    wait $job || let "FAIL+=1"
done

if [ "$FAIL" == "0" ];
then
echo "$Command2 finished." 
else
echo "Fail! ($FAIL)"
fi
