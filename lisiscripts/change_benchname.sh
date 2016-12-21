#!/bin/bash

set -u
set -e
FAIL=0
Counter=1
clients=`cat ./lisiscripts/clients`
nodes=`cat ./lisiscripts/nodes`
first=`head -1 ./lisiscripts/nodes`
rest=`tail -n +2 ./lisiscripts/nodes`
config=`cat ./lisiscripts/config`
string="['nodes1@"$first"'"
for node in $rest
do
    let Counter=Counter+1
    string=$string",'nodes"$Counter"@"$node"'"
done
string=$string"]"
Counter=0
for client in $clients
do
    let Counter=Counter+1
    NodeName="basho_bench$Counter@$client"
	echo $NodeName
    Command2="cd ./basho_bench && sudo sed -i -e \"s/{antidote_mynode.*/{antidote_mynode, ['$NodeName', longnames]}./\" examples/$config"
    ssh -o ConnectTimeout=10 -t ubuntu@$client -i ~/ec2-saturn ${Command2/localhost/$client}
    Command3="cd ./basho_bench && sudo sed -i -e \"s/{antidote_nodes.*/{antidote_nodes, $string}./\" examples/$config"
    ssh -o ConnectTimeout=10 -t ubuntu@$client -i ~/ec2-saturn ${Command3/localhost/$client}
done
echo $Command2 done
