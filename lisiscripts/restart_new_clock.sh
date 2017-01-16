#!/bin/bash

Command0="cd ./li-si && sudo ./rel/antidote/bin/antidote stop"

./lisiscripts/parallel_command.sh nodes "$Command0"

./lisiscripts/change_clock.sh $1

#Command3="cd ./li-si && sudo make relclean"

#./lisiscripts/parallel_command.sh nodes "$Command3"

#Command4="cd ./li-si && make rel"

#./lisiscripts/parallel_command.sh nodes "$Command4"

Command5="cd ./li-si && sudo ./rel/antidote/bin/antidote start"

./lisiscripts/parallel_command.sh nodes "$Command5"

sleep 5

./lisiscripts/joinNodes.sh
