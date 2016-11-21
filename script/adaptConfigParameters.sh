#!/bin/bash

# Example:
# ./adaptConfigParameters.sh clocks.config max 10 180 8 2 pareto_int 100000 5 5

# Information:
# http://docs.basho.com/riak/kv/2.1.4/using/performance/benchmarking/

CONFIG_FILE=${1}

if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Config file not found!"
    exit
fi

if [ ${#} -ne 12 ]; then
    echo "Incorrect number of arguments!"
    exit
fi

sudo sed -i "s/^{mode,.*/{mode, ${2}}./" ${CONFIG_FILE}
sudo sed -i "s/^{concurrent,.*/{concurrent, ${3}}./" ${CONFIG_FILE}
sudo sed -i "s/^{duration,.*/{duration, ${4}}./" ${CONFIG_FILE}
sudo sed -i "s/^{operations,.*/{operations, [{read_txn, ${5}}, {update_txn, ${6}}, {read_update_txn, ${7}}]}./" ${CONFIG_FILE}
sudo sed -i "s/^{key_generator,.*/{key_generator, {${8}, ${9}}}./" ${CONFIG_FILE}
sudo sed -i "s/^{key_per_read_tx,.*/{key_per_read_tx, ${10}}./" ${CONFIG_FILE}
sudo sed -i "s/^{key_per_update_tx,.*/{key_per_update_tx, ${11}}./" ${CONFIG_FILE}
sudo sed -i "s/^{key_per_read_update_tx,.*/{key_per_read_update_tx, ${12}}./" ${CONFIG_FILE}

# Example
# ./script/adaptConfigParameters.sh examples/clocks_local.config max 10 120 5 5 0 uniform_int 500000 5 5 0