#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 19 13:38:15 2019

@author: damian_wollny
"""
#############################
### PARSE MEME TXT OUTPUT ###
#############################

# Simplified version
# Execute script in folder containing meme output!
               
### Generate table with the meme infos of each transcript ###
with open("./meme.csv", "w") as output_file:
    output_file.write("motif, transcript_width, sites, e_value"+"\n")
    with open("./meme.txt") as meme_output:
        for line in meme_output:
            if line.startswith("MOTIF"):
                # split MOTIF line
                trans_split = line.split()
                motif = trans_split[1]
                width = trans_split[5]
                sites = trans_split[8]
                evalue = trans_split[14]
                output = (motif+" "+width+" "+sites+" "+evalue+"\n").replace(" ",",")
                print(output)
                output_file.write(output)
