#ol!/bin/bash

clients="1 2 3 4 5 6 7 8 9 10"
config=`cat ./lisiscripts/config`
for client in $clients;
do
    ./lisiscripts/conf_bench.sh 120 $config 10 10000 uniform_int 0 0 1 0 0 5

    Command1="sudo /usr/sbin/ntpdate -b ntp.ubuntu.com"
    ./lisiscripts/parallel_command.sh nodes "$Command1"

    Command2="cd ./basho_bench && sudo ./basho_bench examples/$config"
    ./lisiscripts/parallel_command.sh clients "$Command2"
    ./lisiscripts/gather_results.sh
done

