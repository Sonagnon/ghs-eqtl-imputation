#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/../utils/config.sh"

mkdir -p "${A_DIR}/gwas" "${LOG_DIR}"

# Phenotype column names to test (must match phenotype_plink.txt header)
PHENOS=("HDL_CHOL" "ApoA1")

echo "== Project A / GWAS (PLINK --linear) =="
echo "Phenotype file: ${PHENO_FILE}"
echo "Covariate file: ${COVAR_FILE} (optional)"
echo

use_covar=0
if [[ -f "${COVAR_FILE}" ]]; then
  use_covar=1
  echo "[INFO] Covariate file found -> will run covariate-adjusted GWAS too."
else
  echo "[INFO] No covariate file -> will run unadjusted GWAS only."
fi
echo

for c in "${CHRS[@]}"; do
  bfile="${A_DIR}/clean/${CHR_PREFIX}${c}_clean"
  echo "---- chr${c} ----"
  echo "Genotypes: ${bfile}"

  for pheno in "${PHENOS[@]}"; do
    outbase="${A_DIR}/gwas/${CHR_PREFIX}${c}_${pheno}_unadj"
    echo "  [GWAS] ${pheno} (unadjusted) -> ${outbase}"
    ${PLINK} \
      --bfile "${bfile}" \
      --pheno "${PHENO_FILE}" \
      --pheno-name "${pheno}" \
      --linear \
      --allow-no-sex \
      --out "${outbase}" \
      2>&1 | tee "${LOG_DIR}/A08_gwas_chr${c}_${pheno}_unadj.log"

    if [[ "${use_covar}" -eq 1 ]]; then
      outbase2="${A_DIR}/gwas/${CHR_PREFIX}${c}_${pheno}_covar"
      echo "  [GWAS] ${pheno} (covariates) -> ${outbase2}"
      ${PLINK} \
        --bfile "${bfile}" \
        --pheno "${PHENO_FILE}" \
        --pheno-name "${pheno}" \
        --covar "${COVAR_FILE}" \
        --covar-name sex,age,BMI \
        --linear \
        --allow-no-sex \
        --out "${outbase2}" \
        2>&1 | tee "${LOG_DIR}/A08_gwas_chr${c}_${pheno}_covar.log" || {
          echo "[WARN] Covariate-adjusted run failed for ${pheno} chr${c}."
          echo "       Maybe your covariate headers differ from age,sex,BMI."
          echo "       We'll fix covar-name later if needed."
        }
    fi
  done
  echo
done

echo "Done ✅ GWAS outputs in: ${A_DIR}/gwas/"
