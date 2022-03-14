#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 10 10:38:15 2020

@author: damian_wollny
"""
#############################
### PARSE MEME TXT OUTPUT ###
#############################

# Get individual motifs for all consensus motifs
with open("./meme_ind_motifs.csv", "w") as output_file:
    output_file.write("motif_number, motif_seqs"+"\n")
    with open("./meme.txt") as meme_output:
        for line in meme_output:
            if line.startswith("MOTIF"):
                spliteted_line = line.split()
                motif_number = spliteted_line[2]
            elif line.startswith("ENST") and line.endswith("1 \n"):
                motif_line = line.split()
                ind_motif = motif_line[3]
                output = (motif_number+" "+ind_motif+"\n").replace(" ",",")
                print(output)
                output_file.write(output)
