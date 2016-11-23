#!/bin/bash
set -u
set -e

./script/adaptConfigParameters.sh examples/clocks.config max 1 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 2 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 5 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results


./script/adaptConfigParameters.sh examples/clocks.config max 8 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 10 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 15 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 13 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 20 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 25 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results


./script/adaptConfigParameters.sh examples/clocks.config max 50 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results


./script/adaptConfigParameters.sh examples/clocks.config max 100 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results