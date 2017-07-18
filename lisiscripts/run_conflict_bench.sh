#!/bin/bash

## The probability (divided by 1000) of accessing a partition, for each key 
PartRate="125"
## The probability (divided by 1000) of a transaction to start in a particular partition.
StartRate="125"
Num="1 2 3"
Distribution="uniform_int pareto_int"

for D in $Distribution
do
    Clocks="logical aggr_logical bravo physical hybrid"
    IfPrecise=false
    for Clock in $Clocks
    do
        ./lisiscripts/restart_new_clock.sh $Clock $IfPrecise 
        for num in $Num
        do
            ./lisiscripts/conf_bench.sh 60 7 10 10000 $D 8 125 125 0 0 5 2 
            ./lisiscripts/run_bench.sh
            ./lisiscripts/summary.sh
            echo "$Clock $IfPrecise 60 7 10 10000 $D 8 125 125 0 0 5 2" > ./results/current/config
        done
    done

    Clocks="logical aggr_logical bravo"
    IfPrecise=true
    for Clock in $Clocks
    do
        ./lisiscripts/restart_new_clock.sh $Clock $IfPrecise 
        for num in $Num
        do
            ./lisiscripts/conf_bench.sh 60 7 10 10000 $D 8 125 125 0 0 5 2 
            ./lisiscripts/run_bench.sh
            ./lisiscripts/summary.sh
            echo "$Clock $IfPrecise 60 7 10 10000 $D 8 125 125 0 0 5 2" > ./results/current/config
        done
    done
done
