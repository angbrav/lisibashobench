#!/bin/bash
set -u
set -e

./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results
