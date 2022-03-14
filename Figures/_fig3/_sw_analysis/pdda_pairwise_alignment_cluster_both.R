# load libraries
library(dplyr)
library(tidyr)
library(stringr)
library(RColorBrewer)
library(Seurat)
library(reshape2)
library(Biostrings)
library(seqinr)
library(gplots)
library(ggplot2)
library(arrangements)

# set working directory
setwd("/mnt/SingleCellGenomics/coacervate_seq/pairwise_alignment/ave_pdda/bens_penalty/")

# open RDS file containing enrichment of transcripts in lysine coacervates
print("loading files")

# open FASTA file containing all input RNA sequences
enr <- read.fasta(file = "./pdda_input_enriched_seqs.txt") #change
rand <- read.fasta(file = "./pdda_input_rand_seqs.txt") #change

# rename to seqs for downstream stuff
seqs <- enr
# function to get the reverse complement of given seq
get_reverse_compl <- function(seq){
  reverse(chartr("ATGC","TACG",seq))  
}
# sigma was used as in link described above
sigma <- nucleotideSubstitutionMatrix(match = 2, mismatch = -1, baseOnly = TRUE)
# get indices for all combinations first
all_pairs <- permutations(x = 1:length(seqs), replace = T, k = 2)
# initiate matrix
mat <- matrix(nrow = length(seqs), ncol = length(seqs), dimnames = list(c(1:length(seqs)),c(1:length(seqs))))
# name cols and rows of matrix -> rows = enriched; cols = random
for (i in 1:length(seqs)){
  rownames(mat)[i] <- names(seqs[i])
  colnames(mat)[i] <- names(rand[i])
}  

# align each transcript to the rc of each transcript
print("starting pairwise alignment")
for (i in 1:nrow(all_pairs)){
  # get two sequences for comparison
  s1 <- toupper(c2s(seqs[[all_pairs[i,][1]]]))
  s2 <- toupper(c2s(rand[[all_pairs[i,][2]]]))
  # get rc of sequence to compare to (s2)
  s2 <- get_reverse_compl(s2)
  # do local pairwise alignments
  mat[all_pairs[i,][1],all_pairs[i,][2]] <- pairwiseAlignment(s1, s2, substitutionMatrix = sigma, gapOpening = -30,
                                                              gapExtension = -0.05, scoreOnly = TRUE, type="local")
  # get matrix symmetrical
  mat[all_pairs[i,][2],all_pairs[i,][1]] <- mat[all_pairs[i,][1],all_pairs[i,][2]]
  print(i)
}

print("saving alignment matrix")
write.table(x = mat, file = "./both_matrix.txt")

# plot data 
print("plotting results")

df <- melt(mat)
df <- df %>% drop_na() 

p1 <- df %>% 
  ggplot(aes(value)) +
  geom_density() +
  scale_x_continuous(trans = "log10") +
  labs(x = "Pairwise Similarity Score\n(Smith-Waterman)", title = paste(paste("Residuals > 30:", length(seqs), sep = " "), "transcripts", sep = " "))

ggsave(filename = "./both_plot.png", plot = p1)


