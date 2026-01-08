#!/usr/bin/env bash
set -euo pipefail

# Load config
source "$(dirname "$0")/../utils/config.sh"

mkdir -p "${LOG_DIR}"

echo "== Project A / Check inputs =="
echo "Project root: ${PROJECT_ROOT}"
echo "Genotypes dir: ${GENO_DIR}"
echo "Phenotype file: ${PHENO_FILE}"
echo "Covariate file (optional): ${COVAR_FILE}"
echo "Chromosomes: ${CHRS[*]}"
echo

fail=0

# 1) Check genotype files per chromosome
for c in "${CHRS[@]}"; do
  base="${GENO_DIR}/${CHR_PREFIX}${c}"
  for ext in bed bim fam; do
    f="${base}.${ext}"
    if [[ ! -f "$f" ]]; then
      echo "[MISSING] $f"
      fail=1
    else
      echo "[OK]      $f"
    fi
  done
done
echo

# 2) Check phenotype file
if [[ ! -f "${PHENO_FILE}" ]]; then
  echo "[MISSING] ${PHENO_FILE}"
  fail=1
else
  echo "[OK]      ${PHENO_FILE}"
  echo "Preview (first 5 lines):"
  head -n 5 "${PHENO_FILE}" || true
  echo
  echo "Field count (first line):"
  head -n 1 "${PHENO_FILE}" | awk '{print NF}'
fi
echo

# 3) Check covariate file (optional)
if [[ -f "${COVAR_FILE}" ]]; then
  echo "[OK]      ${COVAR_FILE}"
  echo "Preview (first 5 lines):"
  head -n 5 "${COVAR_FILE}" || true
else
  echo "[INFO]    No covariate file found (this is optional): ${COVAR_FILE}"
fi
echo

# 4) Exit status
if [[ "$fail" -eq 1 ]]; then
  echo "ERROR: Some required inputs are missing. Fix paths/names in scripts/utils/config.sh or place files in data/."
  exit 1
fi

echo "All required inputs look present ✅"
