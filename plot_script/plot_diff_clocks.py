#!/usr/bin/env python

import matplotlib.pyplot as plt
from pylab import *
import sys
import random
import os
from itertools import chain
import numpy as np
import pandas as pd
import re
import glob
import matplotlib.gridspec as gridspec
from helper import *
from plot_lines import *
from datetime import datetime

def get_nth_field(str_list_list, n):
    new_list = []
    for str_list in str_list_list:
        l = []
        for str in str_list:
            l.append(str.split(' ')[n])
        new_list.append(l)
    return new_list

def build_config_dict(input_folder):
    files=glob.glob(input_folder+"*")
    config_dict={}
    for f in files:
        config_file = os.path.join(f, "config") 
        with open(config_file) as fl:
            config=fl.read().split('\n', 1)[0]
            if config in config_dict:
                config_dict[config].append(f)
            else:
                config_dict[config] = [f]
    return config_dict

def get_throughput(config_list, config_dict):
    throughput_list=[]
    abort_rate_list=[]
    std_list=[]
    i=0
    for l in config_list:
        throughput_list.append([])
        abort_rate_list.append([])
        std_list.append([])
        for config in l:
            folders=config_dict[config]
            th_list = []
            abort_rate = []
            for folder in folders:
                throughput=0
                tried = 0
                abort = 0
                summary= os.path.join(folder, "summary.csv")
                with open(summary) as fl:
                    lines=fl.readlines()
                    lines=lines[1:-1]
                    for li in lines:
                        li=li.split(", ")
                        throughput+=float(li[3])
                        tried+=float(li[2])
                        abort+=float(li[4])
                    th_list.append(throughput/60)
                    abort_rate.append(abort/tried)
            #print(config)
            #print(th_list)
            throughput_list[i].append(np.mean(th_list))
            abort_rate_list[i].append(np.mean(abort_rate))
            std_list[i].append(np.std(th_list))
        i += 1
    return throughput_list, abort_rate_list, std_list

input_folder="/Users/liz/Documents/MyDocument/repositories/lisibashobench/results/fake-physical/results/"
#input_folder="/Users/liz/Documents/MyDocument/repositories/lisibashobench/results/Mar03/results/"
#files=glob.glob(input_folder+"*")
series1=get_matching_series(input_folder, [0, 5, 'physical', 'uniform_int'], 8)
series2=get_matching_series(input_folder, [0, 5, 'fake_physical', 'uniform_int'], 8)
#series2=get_matching_series(input_folder, [0, 5, 'physical', 'pareto_int'], 8)
#series3=get_matching_series(input_folder, [0, 5, 'logical', 'uniform_int'], 8)
#series4=get_matching_series(input_folder, [0, 5, 'logical', 'pareto_int'], 8)
#series5=get_matching_series(input_folder, [0, 5, 'aggr_logical', 'uniform_int'], 8)
#series6=get_matching_series(input_folder, [0, 5, 'aggr_logical', 'pareto_int'], 8)
config_dict=build_config_dict(input_folder)
#print(config_dict)
#print(series1)
#print(series2)
#print(series3)
#print(series4)
#print(series5)
#print(series6)
sr=[900, 700, 500, 200, 100, 10, 1]
#legends=['Physical uniform', 
#         'Physical pareto',
#         'Logical uniform', 
#         'Logical pareto',
#         'AggrLogical uniform', 
#         'AggrLogical pareto']
#legends=['Physical uniform', 
#         'Logical uniform', 
#         'AggrLogical uniform'] 
legends=['Physical uniform', 
         'Fake physical uniform'] 
time=datetime.now().strftime("%Y%m%d-%H:%M:%S")
output_folder='./results/figures/' + time
os.mkdir(output_folder)
for i in range(4):
    ## Start rate 1, 10, 100, 500 
    #total_series=[sort_by_num(series1[i]), sort_by_num(series2[i]), 
    #             sort_by_num(series3[i]), sort_by_num(series4[i]),
    #             sort_by_num(series5[i]), sort_by_num(series6[i])]
    total_series=[sort_by_num(series1[i]), 
                 sort_by_num(series2[i])]
    #total_series=[sort_by_num(series1[i]), 
    #             sort_by_num(series3[i]),
    #             sort_by_num(series5[i])]
                 #sort_by_num(series5[i])]
    th_list, abort_rate_list, std_list = get_throughput(total_series, config_dict)
    #print(total_series)
    nthfield = get_nth_field(total_series, 7)
    #print(abort_rate_list)
    #print(nthfield)
    #print(th_list)
    #print(std_list)
    plot_lines(th_list, abort_rate_list, std_list, nthfield, legends, "Start rate "+str(sr[i]), output_folder)
