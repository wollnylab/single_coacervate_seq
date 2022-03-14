#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr  8 21:40:19 2019

@author: damian_wollny
"""
import re
from Bio import SeqIO

with open("./output/enriched_clean.txt", "w") as output_file:
    output_file.write("transcript_id, free_energy, transcript_pool"+"\n")
    for record in SeqIO.parse("./output/enriched.txt", "fasta"):
        transcript_id = record.id
        free_ernergy = record.seq[-10:]
        free_ernergy = str(free_ernergy).replace('(', '').replace(')', '')
        clean_free_ernergy = re.sub('^\.+', '', free_ernergy)
        output = (transcript_id+" "+ clean_free_ernergy+" "+"enriched_transcripts"+"\n").replace(" ",",")
        print(output)
        output_file.write(output)