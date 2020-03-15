#!/bin/sh

python ../software/ldsc/ldsc.py \
  --h2 output/$1.sumstats.gz \
  --ref-ld-chr data/eur_w_ld_chr/ \
  --w-ld-chr data/eur_w_ld_chr/ \
  --out output/$1