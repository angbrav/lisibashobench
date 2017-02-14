#!/bin/bash

## The probability (divided by 1000) of accessing a partition, for each key 
PartRate="1 10 100 500"
## The probability (divided by 1000) of a transaction to start in a particular partition.
StartRate="1 10 100 500"
Clocks="logical aggr_logical physical"

for Clock in $Clocks
do
    for PR in $PartRate
    do
        for SR in $StartRate
        do
            ./lisiscripts/restart_new_clock.sh $Clock 
            ./lisiscripts/conf_bench.sh 60 1 10 10000 uniform_int 8 $PR $SR 1 0 0 5
            ./lisiscripts/run_bench.sh
            ./lisiscripts/summary.sh
            echo "$Clock 60 7 10 10000 uniform_int 8 $PR $SR 1 0 0 5" > ./results/current/config

            ./lisiscripts/restart_new_clock.sh $Clock 
            ./lisiscripts/conf_bench.sh 60 1 10 10000 pareto_int 8 $PR $SR 1 0 0 5
            ./lisiscripts/run_bench.sh
            ./lisiscripts/summary.sh
            echo "$Clock 60 7 10 10000 pareto_int 8 $PR $SR 1 0 0 5" > ./results/current/config
        done
    done
done
