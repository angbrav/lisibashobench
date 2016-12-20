#!/bin/bash


if [ $# -eq 1 ]
then
    First=`head -1 ./lisiscripts/nodes`
    Others=`awk -v var="$1" 'NR>=2&&NR<=var' ./lisiscripts/nodes`
    echo Parameter:$1 , joinig $Others to $First
else
    First=$1
    Others=$2
    echo "Joining "$Others" to "$First
fi

Join="sudo li-si/rel/antidote/bin/antidote-admin cluster join antidote@$First"
PlanAndCommit="sudo li-si/rel/antidote/bin/antidote-admin cluster plan && sudo li-si/rel/antidote/bin/antidote-admin cluster commit"
for Node in $Others
do
	ssh -o ConnectTimeout=10 -t root@$Node -i /Users/bravogestoso/Projects/ec2-saturn $Join
    	sleep 1
done
ssh -o ConnectTimeout=10 -t root@$First -i /Users/bravogestoso/Projects/ec2-saturn $PlanAndCommit
