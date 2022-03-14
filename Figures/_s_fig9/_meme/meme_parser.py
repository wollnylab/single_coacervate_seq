#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr 19 13:38:15 2019

@author: damian_wollny
"""
#############################
### PARSE MEME TXT OUTPUT ###
#############################
            
# table with the meme infos of each transcript ###
with open("./parsed_meme_output.csv", "w") as output_file:
    output_file.write("motif, motif_enrichment, transcript, start, end, pvalue"+"\n")
     # open meme input file
    with open("/Users/damian_wollny/PD/Data/OoL/18.2_integrative_analysis/_1_comparison/_even_newer_meme_analysis/_ave_pdda_coac/_meme_output/resids/meme.txt") as meme_output:
        for line in meme_output:
            if line.startswith("MOTIF"): 
                trans_split = line.split() # split MOTIF line
                motif = trans_split[1] # MOTIF
                e_val = trans_split[14] # E-value of motif
                width = trans_split[5] # motif width [bp]
            elif line.startswith("ENST"):
                fuk = line.split()
                if len(fuk) == 6 and fuk[1] != "1.0000":
                    output = (motif+" "+e_val+" "+fuk[0]+" "+fuk[1]+" "+str(int(fuk[1])+int(width))+" "+fuk[2]+"\n").replace(" ",",")
                    print(output)
                    output_file.write(output)
                    
