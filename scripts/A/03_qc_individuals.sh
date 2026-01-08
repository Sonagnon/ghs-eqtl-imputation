#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/../utils/config.sh"

mkdir -p "${A_DIR}/qc_individuals" "${LOG_DIR}"

echo "== Project A / Individual QC =="
echo "Filter: --mind ${QC_MIND}"
echo

# We'll use one chromosome for het/IBD computations to avoid redundancy.
# Default: first chromosome in CHRS array (e.g., chr2)
BASE_CHR="${CHRS[0]}"
BASE_IN="${A_DIR}/qc_snps/${CHR_PREFIX}${BASE_CHR}_qc1"
BASE_OUTDIR="${A_DIR}/qc_individuals"

echo "Using base chromosome for het/IBD: chr${BASE_CHR}"
echo "Base input: ${BASE_IN}"
echo

# 1) Individual missingness filter on base chr (to create a clean-ish sample set)
${PLINK} \
  --bfile "${BASE_IN}" \
  --mind "${QC_MIND}" \
  --make-bed \
  --out "${BASE_OUTDIR}/${CHR_PREFIX}${BASE_CHR}_mind" \
  2>&1 | tee "${LOG_DIR}/A03_mind_chr${BASE_CHR}.log"

# 2) Heterozygosity stats
${PLINK} \
  --bfile "${BASE_OUTDIR}/${CHR_PREFIX}${BASE_CHR}_mind" \
  --het \
  --out "${BASE_OUTDIR}/${CHR_PREFIX}${BASE_CHR}_het" \
  2>&1 | tee "${LOG_DIR}/A03_het_chr${BASE_CHR}.log"

# 3) IBD / relatedness (can be heavy; keep default settings for now)
${PLINK} \
  --bfile "${BASE_OUTDIR}/${CHR_PREFIX}${BASE_CHR}_mind" \
  --genome \
  --out "${BASE_OUTDIR}/${CHR_PREFIX}${BASE_CHR}_ibd" \
  2>&1 | tee "${LOG_DIR}/A03_ibd_chr${BASE_CHR}.log"

echo
echo "Outputs:"
echo "- ${BASE_OUTDIR}/${CHR_PREFIX}${BASE_CHR}_het.het   (heterozygosity)"
echo "- ${BASE_OUTDIR}/${CHR_PREFIX}${BASE_CHR}_ibd.genome (IBD pairs)"
echo
echo "Next step: derive indtoremove.txt from het outliers + related individuals."
