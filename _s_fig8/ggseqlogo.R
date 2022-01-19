# Prior to this script: run 'meme_parser_prob_mat.py' to get input files
# great vignette for ggseqlogo found on: https://omarwagih.github.io/ggseqlogo/
library(ggseqlogo)
library(ggplot2)

# set wd
setwd("./")

# function to format parsed meme output
get_in_shape <- function(file){
  the_data <- read.table(file = file, sep = " ", skip = 1)
  mat <- rbind(the_data$V2,the_data$V4, the_data$V6, the_data$V8)
  rownames(mat) <- c("A", "C", "G", "T")
  return(mat)
}

# load all motif_*.txt files and apply the get_in_shape function
mat_list <- lapply(Sys.glob("motif_*.txt"), get_in_shape)

# correct mat_list order and rename
mat_list <- mat_list[c(1,3,4,5,6,7,8,9,10,2)]
names(mat_list) <- paste("Motif:", c(1:10))

# Generate sequence logo
plot <- ggseqlogo(mat_list, method = "bits", font = "helvetica_regular", ncol = 1)
ggsave(plot, filename = "ggseqlogo.pdf", width = 12, height = 14)
