#!/bin/bash

PartRate="1 13 80"
StartRate="1 13 80"
Clocks="logical aggr_logical physical"

for Clock in $Clocks:
do
    for PR in $PartRate:
    do
        for SR in $StartRate:
        do
            ./lisiscripts/restart_new_clock.sh $Clock 
            ./lisiscripts/conf_bench.sh 120 7 10 10000 uniform_int 8 $PR $SR 1 0 0 5
            ./lisiscripts/init_bench.sh ec2
            ./lisiscripts/run_bench.sh
            ./lisiscripts/summary.sh
            echo "$Clock 120 7 10 10000 uniform_int 8 $PR $SR 1 0 0 5" > ./results/current/config
        done
    done
done
