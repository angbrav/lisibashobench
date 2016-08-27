#!/bin/bash

if [ $# -eq 0 ]
then
	AllNodes=`cat script/allnodes`
else
	AllNodes=$1
fi

echo "Stopping nodes:" $AllNodes

StopAndR="sudo li-si/rel/antidote/bin/antidote stop && sudo rm -rf li-si/rel/antidote/data/* && sudo rm -rf li-si/rel/antidote/log/*" 
./script/parallel_command.sh "$AllNodes" "$StopAndR" 
