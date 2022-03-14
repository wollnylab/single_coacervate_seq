#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 19 13:38:15 2019

@author: damian_wollny
"""
#############################
### PARSE MAST TXT OUTPUT ###
#############################

# Execute script in folder containing meme output!

               
### Generate table with the meme infos of each transcript ###
with open("./mast.csv", "w") as output_file:
    output_file.write("target_id, strand, e_value, length"+"\n")
    with open("./mast.txt") as mast_output:
        for line in mast_output:
            if line.startswith("ENST"):
                line_split = line.split()
                if len(line_split) == 4 and line_split[3].isdigit():
                    output = (line_split[0]+" "+line_split[1]+" "+line_split[2]+" "+line_split[3]+"\n").replace(" ",",")
                    print(output)
                    output_file.write(output)