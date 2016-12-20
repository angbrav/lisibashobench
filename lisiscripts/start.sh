#!/bin/bash

Command0="cd ./li_si && sudo ./rel/antidote/bin/antidote stop"

./lisiscripts/parallel_command_all.sh "$Command0"

if [ $# -eq 1 ]
then
    branch=$1
    Command1="cd ./li_si && git reset --hard && git fetch && git checkout $branch && git pull"
else
    Command1="cd ./li_si && git pull origin master"
fi

./lisiscripts/parallel_command_all.sh "$Command1"

./lisiscripts/change_nodename.sh nodes

Command3="cd ./li_si && sudo make relclean"

./lisiscripts/parallel_command_all.sh "$Command3"

Command4="cd ./li_si && make rel"

./lisiscripts/parallel_command_all.sh "$Command4"

Command5="cd ./li_si && sudo ./rel/antidote/bin/antidote start"

./lisiscripts/parallel_command_all.sh "$Command5"
