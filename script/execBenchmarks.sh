#!/bin/bash
set -u
set -e

# Before executing this script use the script changeConfig.sh to configure the number
# of node in the partition and the type of clock used for this evaluation
# Example: ./script/changeConfig.sh 64 physical
# And also the script adaptConfigParameters.sh to adapt the configuration of the basho bench driver
# ./script/adaptConfigParameters.sh examples/clocks.config max 10 120 5 5 0 uniform_int 500000 5 5 0

./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results
