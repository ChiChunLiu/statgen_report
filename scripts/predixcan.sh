#!/bin/sh

run_predixcan () {

tissue=$1
python3 /project2/hgen47100/software2/MetaXcan/software/SPrediXcan.py \
  --model_db_path /project2/hgen47100/data/lab6/predictdb_mashr_eqtl/mashr/mashr_$tissue.db \
  --model_db_snp_key varID \
  --covariance /project2/hgen47100/data/lab6/predictdb_mashr_eqtl/mashr/mashr_$tissue.txt.gz \
  --gwas_file data/gwas/UKB_20002_1452_self_reported_eczema_or_dermatitis.txt.gz \
  --snp_column panel_variant_id \
  --effect_allele_column effect_allele \
  --non_effect_allele_column non_effect_allele \
  --zscore_column zscore \
  --pvalue_column pvalue \
  --keep_non_rsid \
  --output_file output/spredixcan.UKB_dermatitis.$tissue.csv

}

export -f run_predixcan

#run_predixcan Skin_Not_Sun_Exposed_Suprapubic
#run_predixcan Skin_Sun_Exposed_Lower_leg
#run_predixcan Whole_Blood
run_predixcan Cells_EBV-transformed_lymphocytes
