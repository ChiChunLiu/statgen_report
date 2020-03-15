#!/bin/sh

gwas_file=$1

python2 ../software/ldsc/munge_sumstats.py \
  --sumstats data/gwas/$gwas_file.txt.gz \
  --N-col sample_size \
  --snp variant_id \
  --a1 effect_allele \
  --a2 non_effect_allele \
  --signed-sumstats zscore,0 \
  --p pvalue \
  --merge-alleles data/eur_w_ld_chr/w_hm3.snplist \
  --out output/$gwas_file


