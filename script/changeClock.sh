#!/bin/bash

Nodes=`cat script/allnodes`
File1="./li-si/rel/antidote/antidote.config"
File2="./li-si/rel/files/antidote.config"

Command1="sudo sed -i '/clock_type/d' $File1"
Command2="sudo echo {clock_type, $1}. >>$File1"
Command3="sudo sed -i '/clock_type/d' $File2"
Command4="sudo echo {clock_type, $1}. >>$File2"

./script/parallel_command.sh "$Nodes" "$Command1"
./script/parallel_command.sh "$Nodes" "$Command2"
./script/parallel_command.sh "$Nodes" "$Command3"
./script/parallel_command.sh "$Nodes" "$Command4"
