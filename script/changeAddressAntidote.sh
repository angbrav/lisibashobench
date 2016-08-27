#!/bin/bash

File1="./li-si/rel/vars.config"
File2="./li-si/rel/files/app.config"

NodeList=($(cat script/allnodes))

for i in "${NodeList[@]}"
do
	ssh root@${i} "sudo sed -i 's/127.0.0.1/${i}/g' ${File1}"
	ssh root@${i} "sudo sed -i 's/127.0.0.1/${i}/g' ${File2}"
done
