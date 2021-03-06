#ol!/bin/bash


tts="0 30 60 120 240 480 960"
config=`cat ./lisiscripts/config`
for ts in $tts
do
    Command1="sudo /usr/sbin/ntpdate -b ntp.ubuntu.com"
    ./lisiscripts/parallel_command.sh nodes "$Command1"
    sleep $ts

    ./lisiscripts/conf_bench.sh 60 7 10 10000 uniform_int 8 13 13 1 0 0 5
    Command2="cd ./basho_bench && sudo ./basho_bench examples/$config"
    ./lisiscripts/parallel_command.sh clients "$Command2"
    ./lisiscripts/summary.sh
    echo $ts > ./results/current/config
done
