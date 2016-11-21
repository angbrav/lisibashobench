#!/bin/bash

AllNodes=`cat script/allnodes`

Command1="./li-si/rel/antidote/bin/antidote stop"
Command2="cd ./li-si/ && make clean && make rel"

./script/changeAddressAntidote.sh
./script/parallel_command.sh "$Command1"
./script/parallel_command.sh "$Command2"
