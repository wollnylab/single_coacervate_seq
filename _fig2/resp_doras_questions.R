# Question:
# Does the plot in Fig 2c change if I look at different RNA lengths

# Setup
library(tidyverse)
library(cowplot)
library(RColorBrewer)
library(VennDiagram)
library(gridExtra)


theme_set(theme_classic(base_size=14))
setwd(dir = "~/PD/Data/OoL/38_Draft_4/_fig2/")

master <- readRDS(file = "/Users/damian_wollny/PD/Data/OoL/19.1_Draft_2/Generate_input/draft2_input.RDS")

ool17_ave_tpm <- master %>%  
  filter(experiment == "ool17") %>%  
  filter(tpm != 0) %>%  
  group_by(target_id) %>%  
  summarise(ave_tpm = mean(log2_tpm), CV = sd(log2_tpm)/mean(log2_tpm), length = length[1])

ool18_ave_tpm <- master %>%
  filter(experiment == "ool18") %>% 
  filter(tpm != 0) %>% 
  group_by(target_id) %>% 
  summarise(ave_tpm = mean(log2_tpm), CV = sd(log2_tpm)/mean(log2_tpm), length = length[1])

comb_ave_tpm <- left_join(ool17_ave_tpm, ool18_ave_tpm, by = "target_id") %>% drop_na()

s2c_model <- lm(ave_tpm.x ~ ave_tpm.y, comb_ave_tpm) 
s2c_rho <- cor(comb_ave_tpm$ave_tpm.x,comb_ave_tpm$ave_tpm.y)

data <- comb_ave_tpm %>% select(-CV.x, -CV.y) %>% mutate(bin = ntile(length.x, 4))


# Correlation of RNA abundance
ggplot(data = data, aes(x = ave_tpm.x , y = ave_tpm.y)) +
  geom_point(size = 3, alpha = .7, shape = 21) +
  facet_wrap(.~bin) +
  geom_density2d(binwidth = 0.002, colour = "blue", size = .8) +
  geom_abline(intercept = 0, slope = 1, col = "red", size = 1) +
  labs(x = "Ave. RNA amount in condensates\nExperiment A", y = "Ave. RNA amount in condensates\nExperiment B") +
  lims(y = c(0,16), x = c(0,16))


# Question:
# Could there be a weak correlation between experiments because there were size differences between condesnates of the two experiments
master %>% 
  filter(experiment == "ool17" | experiment == "ool18") %>% 
  filter(tpm != 0) %>%
  select(cell_id, FSC, experiment) %>% 
  distinct() %>% 
  ggplot(aes(FSC)) +
  geom_histogram() +
  facet_grid(experiment~.)

# Question:
# Does the plot in Fig 2c change if I look at different coacervate sizes
new_data <- 
  master %>% 
  filter(experiment == "ool17" | experiment == "ool18" ) %>%  
  filter(tpm != 0) %>% 
  mutate(coac_size_bin = ntile(FSC, 6))

p <- list()
corr_df <- data_frame(bin = numeric(),
                      corr = numeric())

for (i in c(1:6)){
  ool17_ave_tpm <- new_data %>%  
    filter(experiment == "ool17") %>%  
    filter(tpm != 0) %>%
    filter(coac_size_bin == i) %>% 
    group_by(target_id) %>%  
    summarise(ave_tpm = mean(log2_tpm), CV = sd(log2_tpm)/mean(log2_tpm), length = length[1])
  
  ool18_ave_tpm <- new_data %>%
    filter(experiment == "ool18") %>% 
    filter(tpm != 0) %>% 
    filter(coac_size_bin == i) %>% 
    group_by(target_id) %>% 
    summarise(ave_tpm = mean(log2_tpm), CV = sd(log2_tpm)/mean(log2_tpm), length = length[1])
  
  comb_ave_tpm <- left_join(ool17_ave_tpm, ool18_ave_tpm, by = "target_id") %>% drop_na()
  s2c_model <- lm(ave_tpm.x ~ ave_tpm.y, comb_ave_tpm) 
  s2c_rho <- cor(comb_ave_tpm$ave_tpm.x,comb_ave_tpm$ave_tpm.y)
  corr_df[i,1] <- i
  corr_df[i,2] <- s2c_rho
  
p[[i]] <- ggplot(data = comb_ave_tpm, aes(x = ave_tpm.x , y = ave_tpm.y)) +
    geom_point(size = 3, alpha = .7, shape = 21) +
    geom_density2d(binwidth = 0.002, colour = "blue", size = .8) +
    geom_abline(intercept = 0, slope = 1, col = "red", size = 1) +
    labs(x = "Ave. RNA amount in condensates\nExperiment A", y = "Ave. RNA amount in condensates\nExperiment B", title = paste("size bin = ", i, sep = "")) +
    lims(y = c(0,16), x = c(0,16))
}
do.call(grid.arrange,p)

