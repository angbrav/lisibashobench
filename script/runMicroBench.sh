#!/bin/bash
set -u
set -e
AllNodes=`cat script/allnodes`

if [ $# -gt 11 ]
then
    concurrent=$1
    master_num=$2
    slave_num=$3
    cache_num=$4
    master_range=$5
    slave_range=$6
    cache_range=$7
    do_specula=$8
    specula_length=$9
    pattern=${10}
    repl_degree=${11}
    process_time=${12}
    folder=${13}
    if [ "$do_specula" == true ]; then
	fast_reply=true
    else
	fast_reply=false
    fi
    Seq=${14}
else
    echo "Wrong usage: concurrent, master_num, slave_num, cache_num, master_range, slave_range, cache_range, do_specula, fast_reply, specula_length, pattern, repl_degree, folder"
    exit
fi


#Params: nodes, cookie, num of dcs, num of nodes, if connect dcs, replication or not, branch
Time=`date +'%Y-%m-%d-%H%M%S'`
Folder=$folder/$Time
echo "Folder to make is" $Folder
mkdir $Folder
touch $Folder/$Seq
echo $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} > $Folder/config
sudo rm -f config
echo ant concurrent $1 >> config 
echo micro concurrent $1 >> config 
echo micro master_num $master_num  >> config
echo micro slave_num $slave_num >> config
echo micro cache_num $cache_num >> config
echo micro master_range $master_range >> config
echo micro slave_range $slave_range >> config
echo micro cache_range $cache_range >> config
echo micro process_time $process_time >> config
echo micro pattern $pattern >> config
echo micro duration 60 >> config
echo micro specula $do_specula >> config
#ToSleep=$((40000 / ${1}))
NumNodes=`cat ./script/allnodes | wc -l`
MasterToSleep=$((NumNodes*1000+7000))
ToSleep=$(((10000 + 500*NumNodes) / ${1}))
echo micro master_to_sleep $MasterToSleep >> config
echo micro to_sleep $ToSleep >> config
#echo load to_sleep 35000 >> config

sudo ./script/copy_to_all.sh ./config ./basho_bench/
sudo ./script/parallel_command.sh "cd basho_bench && sudo ./script/config_by_file.sh"

./script/clean_data.sh
#sleep 10

./script/parallel_command.sh "cd basho_bench && sudo mkdir -p tests && sudo ./basho_bench examples/micro.config"
#wait

./script/gatherThroughput.sh $Folder &
./script/copyFromAll.sh prep ./basho_bench/tests/current/ $Folder & 
./script/copyFromAll.sh txn_latencies.csv ./basho_bench/tests/current/ $Folder & 
wait
./script/getAbortStat.sh `head -1 ./script/allnodes` $Folder 

timeout 60 ./script/fetchAndParseStat.sh $Folder
if [ $? -eq 124 ]; then
    timeout 60 ./script/fetchAndParseStat.sh $Folder
    if [ $? -eq 124 ]; then
        timeout 60 ./script/fetchAndParseStat.sh $Folder
    fi
fi

sudo pkill -P $$
