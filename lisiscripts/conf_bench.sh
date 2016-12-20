#!/bin/bash

#Duration=$1 (seconds)
#Concurrent=$2
#Value=$3
#Keys=$4
#Distribution=$5
#{operations, [{read_txn, $6}, {update_txn, $7}, {read_update_txn, $8}]}.
#key_per_read_tx, $9
#key_per_update_tx, $10
#key_per_read_update_tx, $11

Duration=$1
Clients=$2
Value=$3
Keys=$4
Distribution=$5
ReadTx=$6
UpdateTx=$7
Tx=$8
KRTx=$9
KUTx=${10}
KTx=${11}

./lisiscripts/set_bench_param.sh "{duration.*/{duration, $Duration}"
./lisiscripts/set_bench_param.sh "{concurrent.*/{concurrent, $Clients}"
./lisiscripts/set_bench_param.sh "{value_generator.*/{value_generator, {fixed_bin, $Value}}"
./lisiscripts/set_bench_param.sh "{key_generator.*/{key_generator, {$Distribution, $Keys}}"
./lisiscripts/set_bench_param.sh "{operations.*/{operations, [{read_txn, $ReadTx}, {update_txn, $UpdateTx}, {read_update_txn, $Tx}]}"
./lisiscripts/set_bench_param.sh "{key_per_read_tx.*/{key_per_read_tx, $KRTx}"
./lisiscripts/set_bench_param.sh "{key_per_update_tx.*/{key_per_update_tx, $KUTx}"
./lisiscripts/set_bench_param.sh "{key_per_read_update_tx.*/{key_per_read_update_tx, $KTx}"

