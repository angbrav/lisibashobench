#!/usr/bin/env python

import matplotlib.pyplot as plt
from pylab import *
from helper import *
import sys
import random
import os
import numpy as np


def get_lines(input_file):
    lat_list=[]
    with open(input_file) as f:
        for line in f:
            lat_list.append(int(line[:-1])/1000) 
    return lat_list

def plot_cdf(lat_list, output_name, output_folder):
    plt.figure()

    width=1
    marksize=1
    markers=['.']
    colors=['#345353']
    stride = max( int(len(lat_list) / 1000000), 1)
    plt.plot(np.sort(lat_list), np.linspace(0, 1, len(lat_list), endpoint=False), color=colors[0], marker=markers[0], linewidth=width,  markersize=marksize, markevery=stride)

    plt.grid(True)
    plt.tight_layout()
    plt.savefig(output_folder+'/'+output_name+'.png', bbox_inches='tight')

# Output latency
f='./tests/current/latency'
latency=get_lines(f)
plot_cdf(latency, 'latencycdf', 'tests/current/')

# Output missed versions
f='./tests/current/missed_version'
missed_version=get_lines(f)
plot_cdf(missed_version, 'missed_versioncdf', 'tests/current/')

# Output waited latency
f='./tests/current/wait_latency'
wait_latency=get_lines(f)
plot_cdf(wait_latency, 'wait_latencycdf', 'tests/current/')
