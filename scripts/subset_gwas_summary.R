library(tidyverse)
library(data.table)
setwd('Desktop/workspace/statgen2020/final/data/gwas/')
summary <- fread('UKB_20002_1452_self_reported_eczema_or_dermatitis.txt.gz')

summary_sub <- summary %>% 
  filter(pvalue < 1e-4)


fwrite(summary_sub, 'UKB_20002_1452_self_reported_eczema_or_dermatitis.1e-4.txt', sep = '\t')
nrow(summary_sub)
