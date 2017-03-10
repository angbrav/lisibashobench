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
    std_list=[]
    i=0
    for l in config_list:
        throughput_list.append([])
        std_list.append([])
        for config in l:
            folders=config_dict[config]
            th_list = []
            for folder in folders:
                throughput=0
                summary= os.path.join(folder, "summary.csv")
                with open(summary) as fl:
                    lines=fl.readlines()
                    lines=lines[1:-1]
                    for li in lines:
                        li=li.split(", ")
                        throughput+=float(li[3])
                    th_list.append(throughput/60)
            print(config)
            print(th_list)
            throughput_list[i].append(np.mean(th_list))
            std_list[i].append(np.std(th_list))
        i += 1
    return throughput_list, std_list

input_folder="/Users/liz/Documents/MyDocument/repositories/lisibashobench/results/Mar03/results/"
#files=glob.glob(input_folder+"*")
series1=get_matching_series(input_folder, [0, 5, 'physical', 'uniform_int'], 8)
#series2=get_matching_series(input_folder, [0, 5, 'physical', 'pareto_int'], 8)
series3=get_matching_series(input_folder, [0, 5, 'logical', 'uniform_int'], 8)
#series4=get_matching_series(input_folder, [0, 5, 'logical', 'pareto_int'], 8)
series5=get_matching_series(input_folder, [0, 5, 'aggr_logical', 'uniform_int'], 8)
#series6=get_matching_series(input_folder, [0, 5, 'aggr_logical', 'pareto_int'], 8)
config_dict=build_config_dict(input_folder)
#print(config_dict)
#print(series1)
#print(series2)
#print(series3)
#print(series4)
#print(series5)
#print(series6)
sr=[500, 100, 10, 1]
#legends=['Physical uniform', 
#         'Physical pareto',
#         'Logical uniform', 
#         'Logical pareto',
#         'AggrLogical uniform', 
#         'AggrLogical pareto']
legends=['Physical uniform', 
         'Logical uniform', 
         'AggrLogical uniform'] 
output_folder='./results/figures/'
for i in range(4):
    ## Start rate 1, 10, 100, 500 
    #total_series=[sort_by_num(series1[i]), sort_by_num(series2[i]), 
    #             sort_by_num(series3[i]), sort_by_num(series4[i]),
    #             sort_by_num(series5[i]), sort_by_num(series6[i])]
    total_series=[sort_by_num(series1[i]), 
                 sort_by_num(series3[i]),
                 sort_by_num(series5[i])]
    th_list, std_list = get_throughput(total_series, config_dict)
    print(th_list)
    print(std_list)
    plot_lines(th_list, std_list, [1, 10, 100, 500], legends, "Start rate "+str(sr[i]), output_folder)
