#!/bin/bash

./lisiscripts/gather_results.sh
./lisiscripts/merge_thput.sh
cat results/current/summary.csv
