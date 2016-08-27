#!/bin/bash

Command1="cd li-si && git reset --hard && git pull"
./script/parallel_command.sh "$Command1"