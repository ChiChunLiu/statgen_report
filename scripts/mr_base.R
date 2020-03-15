library(devtools)
install_github("MRCIEU/TwoSampleMR")
library(TwoSampleMR)
library(tidyverse)
#ao %>% 
#  filter(stringr::str_detect(id, 'ukb-b-18593')) %>%
#  select(id, trait)
# List available GWASs
ao <- available_outcomes()
# 20261-ever smoked 469-num cigarette
# 12648-supp 18593-VD 18675-deficiency
inst_dat <- extract_instruments(outcomes='ukb-b-20261') 
# 20141:eczema 17670:MS
out_dat <- extract_outcome_data(snps = inst_dat$SNP, outcomes = 'ukb-b-20141') 
#> Extracting data for 79 SNP(s) from 1 GWAS(s)
dat <- harmonise_data(inst_dat, out_dat)

res <- mr(dat)


p1 <- mr_scatter_plot(res, dat)
p1[[1]]



res_single <- mr_singlesnp(dat)
p2 <- mr_forest_plot(res_single)
p2[[1]]
