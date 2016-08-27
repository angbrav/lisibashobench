#!/bin/bash

file1=examples/clocks.config

mynode=($(cat script/bashobenchnode))
nodes=($(cat script/allnodes))

sed -i "s/127.0.0.1/$(echo $mynode)/g" ${file1}

s="['"
for ((i=0; i<${#nodes[*]}; i++))
do
	s+="antidote@"
	s+=${nodes[i]}
	if [ $i -ne $((${#nodes[@]} - 1)) ]
		then
			s+="','"
	fi
done
s+="']"
sed -i "s/nodes_var/$(echo $s)/g" ${file1}