#!/bin/bash
set -u
set -e

# TBU: Refactor

./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/changeConfig.sh 64 logical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/changeConfig.sh 64 logical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/changeConfig.sh 64 hybrid
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/changeConfig.sh 64 hybrid
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/changeConfig.sh 64 hybrid2
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/changeConfig.sh 64 hybrid2
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results
