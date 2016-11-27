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

./script/adaptConfigParameters.sh examples/clocks.config max 4 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 7 120 1 9 0 uniform_int 500000 5 5 0
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

./script/adaptConfigParameters.sh examples/clocks.config max 13 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 16 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 19 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 22 120 1 9 0 uniform_int 500000 5 5 0
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


./script/adaptConfigParameters.sh examples/clocks.config max 28 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results


./script/adaptConfigParameters.sh examples/clocks.config max 31 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 34 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 37 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 40 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 43 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 46 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 49 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 52 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results

./script/adaptConfigParameters.sh examples/clocks.config max 55 120 1 9 0 uniform_int 500000 5 5 0
./script/changeConfig.sh 64 physical
./script/restartAndConnect.sh
./script/changeAddressBasho.sh
./script/synchronizeClock.sh
./basho_bench examples/clocks.config
cp ./script/config.txt ./tests/current
make results
