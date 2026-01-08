#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/../utils/config.sh"

mkdir -p "${A_DIR}/qc_snps" "${LOG_DIR}"

echo "== Project A / SNP QC =="
echo "Filters: --geno ${QC_GENO} --maf ${QC_MAF} --hwe ${QC_HWE}"
echo

for c in "${CHRS[@]}"; do
  inbase="${GENO_DIR}/${CHR_PREFIX}${c}"
  outbase="${A_DIR}/qc_snps/${CHR_PREFIX}${c}_qc1"

  echo "---- chr${c} ----"
  echo "Input : ${inbase}"
  echo "Output: ${outbase}"

  # Basic SNP QC filtering
  ${PLINK} \
    --bfile "${inbase}" \
    --geno "${QC_GENO}" \
    --maf "${QC_MAF}" \
    --hwe "${QC_HWE}" \
    --make-bed \
    --out "${outbase}" \
    2>&1 | tee "${LOG_DIR}/A02_qc_snps_chr${c}.log"

  echo
done

echo "Done ✅ SNP QC outputs in: ${A_DIR}/qc_snps/"
