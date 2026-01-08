#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/../utils/config.sh"

mkdir -p "${A_DIR}/clean" "${LOG_DIR}"

REMOVE_LIST="${A_DIR}/qc_individuals/indtoremove.txt"

echo "== Project A / Make clean datasets =="
echo "Remove list: ${REMOVE_LIST}"
echo

for c in "${CHRS[@]}"; do
  inbase="${A_DIR}/qc_snps/${CHR_PREFIX}${c}_qc1"
  outbase="${A_DIR}/clean/${CHR_PREFIX}${c}_clean"

  echo "---- chr${c} ----"
  echo "Input : ${inbase}"
  echo "Output: ${outbase}"

  ${PLINK} \
    --bfile "${inbase}" \
    --remove "${REMOVE_LIST}" \
    --make-bed \
    --out "${outbase}" \
    2>&1 | tee "${LOG_DIR}/A07_make_clean_chr${c}.log"

  echo
done

echo "Done ✅ Clean datasets in: ${A_DIR}/clean/"
