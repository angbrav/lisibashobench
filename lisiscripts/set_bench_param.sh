#!/bin/bash

set -u
set -e

config=`cat ./lisiscripts/config`
mapfile -t myArray < ~/myconf 
for f in "${myArray[@]}"
do
    arr=($f)
    arr1="${arr[0]}"
    arr2="${arr[1]}"
    echo $arr1	
    echo $arr2	
    sed -i "s/$arr1/$arr2/" examples/$config
done
