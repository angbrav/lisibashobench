#!/bin/bash
set -u
set -e

NBR_PARAMS=$(cat script/benchmarks2Config.txt | grep max | wc -l | sed 's/[^0-9]*//g')

for((i=0; i<${NBR_PARAMS}; i ++)); do
    LINE_CONFIG=$(( ${i} * 3 + 1))
    ./script/adaptConfigParameters.sh examples/clocks.config $(sed "${LINE_CONFIG}q;d" script/benchmarks2Config.txt)
    LINE_CLOCK=$(( ${i} * 3 + 2 ))
    ./script/changeConfig.sh $(sed "${LINE_CLOCK}q;d" script/benchmarks2Config.txt)
    ./script/restartAndConnect.sh
    ./script/changeAddressBasho.sh
    ./script/synchronizeClock.sh
    ./basho_bench examples/clocks.config
    cp ./script/config.txt ./tests/current
    make results
done
