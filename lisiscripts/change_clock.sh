#!/bin/bash

set -u
set -e
FAIL=0
command="setting clock to: $1, setting if precise to: $2"
nodes=`cat ./lisiscripts/nodes`
echo $command" for nodes:"$nodes
for node in $nodes
do
    Command2="cd ./li-si && sudo sed -i -e 's#{clock_type.*#{clock_type, $1}.#' rel/files/antidote.config && sudo sed -i -e 's#{if_precise.*#{if_precise, $2}.#' rel/files/antidote.config"
    ssh -o ConnectTimeout=10 -t ubuntu@$node -i ~/ec2-saturn ${Command2/localhost/$node} &
    Command3="cd ./li-si && sudo sed -i -e 's#{clock_type.*#{clock_type, $1}.#' rel/antidote/antidote.config && sudo sed -i -e 's#{if_precise.*#{if_precise, $2}.#' rel/antidote/antidote.config"
    ssh -o ConnectTimeout=10 -t ubuntu@$node -i ~/ec2-saturn ${Command3/localhost/$node} &
done
echo $command done

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
