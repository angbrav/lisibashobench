#!/bin/bash

Duration=$1
Clients=$2
Value=$3
Keys=$4
Distribution=$5
NP=$6
Rate=$7
KRTx=$8
KUTx=$9
KTx=${10}

./lisiscripts/set_bench_param.sh "{duration.*/{duration, $Duration}"
./lisiscripts/set_bench_param.sh "{concurrent.*/{concurrent, $Clients}"
./lisiscripts/set_bench_param.sh "{value_generator.*/{value_generator, {fixed_bin, $Value}}"
./lisiscripts/set_bench_param.sh "{key_generator.*/{key_generator, {$Distribution, $Keys}}"
./lisiscripts/set_bench_param.sh "{num_partitions.*/{num_partitions, $NP}"
./lisiscripts/set_bench_param.sh "{skewed_part_rate.*/{skewed_part_rate, $Rate}"
./lisiscripts/set_bench_param.sh "{key_per_read_tx.*/{key_per_read_tx, $KRTx}"
./lisiscripts/set_bench_param.sh "{key_per_update_tx.*/{key_per_update_tx, $KUTx}"
./lisiscripts/set_bench_param.sh "{key_per_read_update_tx.*/{key_per_read_update_tx, $KTx}"

