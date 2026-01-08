#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/../utils/config.sh"

mkdir -p "${A_DIR}/pca" "${LOG_DIR}"

BASE_CHR="${CHRS[0]}"
INBASE="${A_DIR}/qc_individuals/${CHR_PREFIX}${BASE_CHR}_mind"
REMOVE_LIST="${A_DIR}/qc_individuals/indtoremove.txt"
OUTBASE="${A_DIR}/pca/${CHR_PREFIX}${BASE_CHR}_pca"

echo "== Project A / PCA for outlier detection =="
echo "Input base: ${INBASE}"
echo "Remove list: ${REMOVE_LIST}"
echo "Output: ${OUTBASE}"
echo

# Remove individuals flagged previously, then compute PCA
${PLINK} \
  --bfile "${INBASE}" \
  --remove "${REMOVE_LIST}" \
  --pca 20 \
  --out "${OUTBASE}" \
  2>&1 | tee "${LOG_DIR}/A05_pca_chr${BASE_CHR}.log"

echo
echo "PCA outputs:"
echo "- ${OUTBASE}.eigenvec"
echo "- ${OUTBASE}.eigenval"
echo
echo "Next: plot PC1/PC2 and optionally flag outliers."
