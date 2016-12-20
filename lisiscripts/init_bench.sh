#!/bin/bash

if [ $# -eq 1 ]
then
    branch=$1
    Command1="cd ./basho_bench/ && git reset --hard && git fetch && git checkout $branch && git pull"
else
    Command1="cd ./basho_bench && git stash save --keep-index && git pull origin ec2"
fi

./lisiscripts/parallel_command.sh clients "$Command1"

Command2="cd ./basho_bench && sudo make all"

./lisiscripts/parallel_command.sh clients "$Command2"

./lisiscripts/change_benchname.sh
