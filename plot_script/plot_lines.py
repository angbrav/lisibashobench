#!/usr/bin/env python3

import matplotlib.pyplot as plt
from pylab import *
from helper import *
import sys
import random
import os
import numpy as np


# input data
def plot_lines(throughput, x_labels, legends, caption, output_folder):
    plot_lines(throughput, [], x_labels, legends, caption, output_folder)

def plot_lines(throughput, abort_rate, std, x_labels, legends, caption, output_folder):
    fig, ax1 = plt.subplots()
    ax2 = ax1.twinx()
    width = 0.35
    maxv=0
    handlers = []
    legend = list() 
    data_l = []
    markers=["^", "8", "s", "h", "v", "D", "v"]
    dashed_ls = ['-', '--']
    line_index=0
    colors=['#000000', '#253494', '#2c7fb8', '#41b6c4', '#a1dab4', '#ffffcc']
    handlers=[]
    for i, th  in enumerate(throughput):
        #print(th)
        #hlt,  = plt.plot(th, color=colors[i/2], linewidth=1.5, marker=markers[i/2], ls=dashed_ls[i%2])
        if std == []:
            hlt,  = ax1.plot(x_labels[i], th, color=colors[i], linewidth=1.5, marker=markers[i])
            #hlt,  = plt.plot(th, color=colors[i], linewidth=1.5, marker=markers[i])
        else:
            #print(th)
            #print(len(th))
            #print(std[i])
            #print([j for j in range(len(th))])
            hlt  = ax1.errorbar(x_labels[i], th, yerr=std[i], color=colors[i], linewidth=1.5, marker=markers[i])
            #hlt  = plt.errorbar([j for j in range(len(th))], th, yerr=std[i], color=colors[i], linewidth=1.5, marker=markers[i])
        ax2.plot(x_labels[i], abort_rate[i], color=colors[i], linestyle='--', linewidth=1.5, marker=markers[i])
        handlers.append(hlt)

    plt.legend(handlers, legends, loc=0, labelspacing=0.1, handletextpad=0.15, borderpad=0.26)
    ax1.set_ylim(0,2100)
    #plt.xlim(0.8,1000)
    ax1.set_xlim(0,1000)
    ax2.set_xlim(0,1000)
    ax2.set_ylim(0,1)
    #plt.xscale("log", nonposx='clip')

    plt.savefig(output_folder+'/'+caption+'.pdf', format='pdf', bbox_inches='tight')
