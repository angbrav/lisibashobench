#ol!/bin/bash

#Duration=$1 (seconds)
#Concurrent=$2
#Value=$3
#Keys=$4
#Distribution=$5
#{operations, [{read_txn, $6}, {update_txn, $7}, {read_update_txn, $8}]}.
#key_per_read_tx, $9
#key_per_update_tx, $10
#key_per_read_update_tx, $11

./lisiscripts/conf_bench.sh 120 10 10 10000 uniform_int 0 0 1 0 0 5

Command1="sudo /usr/sbin/ntpdate -b ntp.ubuntu.com"
./lisiscripts/parallel_command.sh nodes "$Command1"

Command2="cd ./basho_bench && sudo ./basho_bench $config"

#./lisiscripts/parallel_command.sh clients "$Command2"
