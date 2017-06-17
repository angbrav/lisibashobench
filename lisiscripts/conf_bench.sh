#!/bin/bash

Duration=$1
Clients=$2
Value=$3
Keys=$4
Distribution=$5
NP=$6
Rate=$7
Start=$8
KRTx=$9
KUTx=${10}
KTx=${11}
PartToAccess=${12}

./lisiscripts/set_bench_param.sh "{duration.*/{duration, $Duration}"
./lisiscripts/set_bench_param.sh "{concurrent.*/{concurrent, $Clients}"
./lisiscripts/set_bench_param.sh "{value_generator.*/{value_generator, {fixed_bin, $Value}}"
./lisiscripts/set_bench_param.sh "{key_generator.*/{key_generator, {$Distribution, $Keys}}"
./lisiscripts/set_bench_param.sh "{num_partitions.*/{num_partitions, $NP}"
./lisiscripts/set_bench_param.sh "{skewed_part_rate.*/{skewed_part_rate, $Rate}"
./lisiscripts/set_bench_param.sh "{start_in_straggler.*/{start_in_straggler, $Start}"
./lisiscripts/set_bench_param.sh "{key_only_read.*/{key_only_read, $KRTx}"
./lisiscripts/set_bench_param.sh "{key_only_update.*/{key_only_update, $KUTx}"
./lisiscripts/set_bench_param.sh "{key_read_update.*/{key_read_update, $KTx}"
./lisiscripts/set_bench_param.sh "{part_to_access.*/{part_to_access, $PartToAccess}"

