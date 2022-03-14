RNAfold analysis:

Purpose:
Analysis from /Users/damian_wollny/PD/Data/OoL/18.2_integrative_analysis/_4_motif_modelling suggested that there might be something related to "internal folding". So let's look again a bit more into that

Execution:
as in 12.2 but with more complex input: as input files I took all enriched transcripts which I also used for the smith waterman analysis on the cluster (see: /Users/damian_wollny/PD/Data/OoL/18.2_integrative_analysis/_5_pairwise_alignment/_Smith_Watermann/_cluster)

- sw_input_enriched_seqs.txt -> enriched transcripts (residuals > 30)
- sw_input_random_seqs.txt -> random control transcripts (residuals < 30)

both, enriched and control transcript pools are length matched

Execution:
1.) run RNAfold on cluster:
command for RNAfold was:
RNAfold ./input/pop_rnas_high.txt > ./output/pop_rnas_high_output.txt

1.) Parse RNAfold output for analysis in R:
Run following python script: parse_rnafold_output.py
Input: RNAfold output *.txt file
Output: [RNAfold_output_filename]_clean.txt
Note: This is a quick hack. Path to input and output files as well as 'transcript_pool' needs to be changed by hand.

2.) Run free_energy.Rmd for data analysis