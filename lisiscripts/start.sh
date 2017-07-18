#!/bin/bash

Command0="cd ./li-si && sudo ./rel/antidote/bin/antidote stop"

./lisiscripts/parallel_command.sh nodes "$Command0"

if [ $# -eq 1 ]
then
    branch=$1
    Command0="cd ./li-si && git reset --hard && git fetch"
    ./lisiscripts/parallel_command.sh nodes "$Command0"
    Command1="cd ./li-si && git checkout $branch && git pull"
    ./lisiscripts/parallel_command.sh nodes "$Command1"
else
    Command1="cd ./li-si && git pull origin ec2"
    ./lisiscripts/parallel_command.sh nodes "$Command1"
fi


./lisiscripts/change_nodename.sh nodes

Command3="cd ./li-si && sudo make relclean"

./lisiscripts/parallel_command.sh nodes "$Command3"

Command4="cd ./li-si && make rel"

./lisiscripts/parallel_command.sh nodes "$Command4"

Command5="cd ./li-si && sudo ./rel/antidote/bin/antidote start"

./lisiscripts/parallel_command.sh nodes "$Command5"
