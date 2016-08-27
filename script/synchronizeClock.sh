#!/bin/bash

Command1="sudo /usr/sbin/ntpdate -b ntp.ubuntu.com"
./script/parallel_command.sh "$Command1"
