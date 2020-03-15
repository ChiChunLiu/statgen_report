#!/bin/sh

trait1="UKB_20002_1452_self_reported_eczema_or_dermatitis"
trait2="UKB_20002_1111_self_reported_asthma"
out="dermatitis_asthma"

python ../software/ldsc/ldsc.py \
--rg output/$trait1.sumstats.gz,output/$trait2.sumstats.gz \
--ref-ld-chr data/eur_w_ld_chr/ \
--w-ld-chr data/eur_w_ld_chr/ \
--out output/$out