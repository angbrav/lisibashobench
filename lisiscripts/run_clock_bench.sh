#!/bin/bash

## The probability (divided by 1000) of accessing a partition, for each key 
PartRate="1 10 100 500"
## The probability (divided by 1000) of a transaction to start in a particular partition.
StartRate="1 10 100 500"
Clocks="logical aggr_logical physical"
Num="1 2"

IfPrecise=false
for Clock in $Clocks
do
    for PR in $PartRate
    do
        for SR in $StartRate
        do
            ./lisiscripts/restart_new_clock.sh $Clock $IfPrecise 
            for num in $Num
            do
                ./lisiscripts/conf_bench.sh 60 7 10 10000 uniform_int 8 $PR $SR 0 0 10 2 
                ./lisiscripts/run_bench.sh
                ./lisiscripts/summary.sh
                echo "$Clock $IfPrecise 60 7 10 10000 uniform_int 8 $PR $SR 0 0 10 2" > ./results/current/config
            done
        done
    done
done

Clocks="logical aggr_logical"
IfPrecise=true
for Clock in $Clocks
do
    for PR in $PartRate
    do
        for SR in $StartRate
        do
            ./lisiscripts/restart_new_clock.sh $Clock $IfPrecise 
            for num in $Num
            do
                ./lisiscripts/conf_bench.sh 60 7 10 10000 uniform_int 8 $PR $SR 0 0 10 2 
                ./lisiscripts/run_bench.sh
                ./lisiscripts/summary.sh
                echo "$Clock $IfPrecise 60 7 10 10000 uniform_int 8 $PR $SR 0 0 10 2" > ./results/current/config
            done
        done
    done
done
