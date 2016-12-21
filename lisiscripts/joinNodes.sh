#!/bin/bash


First=`head -1 ./lisiscripts/nodes`
Others=`tail -n +2 ./lisiscripts/nodes`
echo joinig $Others to $First

Join="sudo li-si/rel/antidote/bin/antidote-admin cluster join nodes1@$First"
PlanAndCommit="sudo li-si/rel/antidote/bin/antidote-admin cluster plan && sudo li-si/rel/antidote/bin/antidote-admin cluster commit"
for Node in $Others
do
	ssh -o ConnectTimeout=10 -t ubuntu@$Node -i ~/ec2-saturn $Join
    	sleep 1
done
ssh -o ConnectTimeout=10 -t ubuntu@$First -i ~/ec2-saturn $PlanAndCommit
