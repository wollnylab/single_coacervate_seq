#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 15 13:38:15 2020

@author: damian_wollny
"""
##############################
### PARSE MEME PROB MATRIX ###
##############################
import os

counter = 0

with open("./meme.txt") as meme_output:
    for line in meme_output:
        if line.startswith("\t") and line.endswith("probability matrix\n"):
            counter = counter + 1
            new_line = line.split(sep=" ")
            pre = "motif_" + str(counter)
            filename = "%s.txt" % pre
            with open(filename, "w") as test:
                test.write(new_line[1] + "\n")
        if line.startswith(" 0"):
            with open(filename, "a") as fuck:
                fuck.write(line)
