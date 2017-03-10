#ol!/bin/bash

#Duration=$1 (seconds)
#Concurrent=$2
#Value=$3
#Keys per partition=$4
#Distribution=$5
#number of partitions $6
#percetange partition least used $7
#key_per_read_tx, $8
#key_per_update_tx, $9
#key_per_read_update_tx, $10

config=`cat ./lisiscripts/config`

#./lisiscripts/conf_bench.sh 120 7 10 10000 uniform_int 8 10 0 0 5

Command1="sudo /usr/sbin/ntpdate -b ntp.ubuntu.com"
./lisiscripts/parallel_command.sh nodes "$Command1"

Command2="cd ./basho_bench && sudo ./basho_bench examples/$config"

./lisiscripts/parallel_command.sh clients "$Command2"
