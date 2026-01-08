#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../utils/config.sh"

mkdir -p "${A_DIR}/gwas_merged" "${LOG_DIR}"

PHENOS=("HDL_CHOL" "ApoA1")
MODELS=("unadj" "covar")

echo "== Project A / Merge GWAS results =="

for pheno in "${PHENOS[@]}"; do
  for model in "${MODELS[@]}"; do
    out="${A_DIR}/gwas_merged/${pheno}_${model}.assoc.linear.tsv"

    first=1
    wrote_any=0

    for c in "${CHRS[@]}"; do
      f="${A_DIR}/gwas/${CHR_PREFIX}${c}_${pheno}_${model}.assoc.linear"
      if [[ -f "$f" ]]; then
        wrote_any=1
        if [[ "$first" -eq 1 ]]; then
          # keep header
          awk 'BEGIN{OFS="\t"} {print}' "$f" > "$out"
          first=0
        else
          # skip header line
          awk 'NR>1{print}' "$f" >> "$out"
        fi
      fi
    done

    if [[ "$wrote_any" -eq 1 ]]; then
      echo "[OK] Wrote $out"
    else
      echo "[SKIP] No files found for ${pheno} ${model}"
    fi
  done
done

echo "Done ✅"
