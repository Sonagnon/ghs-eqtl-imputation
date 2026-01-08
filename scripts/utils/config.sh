#!/usr/bin/env bash
set -euo pipefail

# --- Project-wide configuration ---

# Chromosomes available in the project (from the assignment)
CHRS=(2 5 13 16)

# Root directories
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DATA_DIR="${PROJECT_ROOT}/data"
RESULTS_DIR="${PROJECT_ROOT}/results"

# Raw inputs (not versioned)
GENO_DIR="${DATA_DIR}/raw/genotypes"
PHENO_FILE="${DATA_DIR}/raw/phenotypes/phenotype_plink.txt"
COVAR_FILE="${DATA_DIR}/raw/covariates/covar_plink.txt"   # optional

# Reference panel for Project B (1000 Genomes Phase 3)
REF_1000G_DIR="${DATA_DIR}/reference/1000G_phase3"

# Naming convention for genotype files:
# expected: chr2.bed/bim/fam, chr5..., chr13..., chr16...
# (you can change the prefix below if your files are named differently)
CHR_PREFIX="chr"

# QC thresholds (defaults; adjust later)
QC_GENO="0.02"   # SNP missingness
QC_MIND="0.02"   # individual missingness
QC_MAF="0.01"
QC_HWE="1e-6"

# Tools
PLINK="plink"    # or plink2 if you prefer
R_BIN="Rscript"

# Output structure
A_DIR="${RESULTS_DIR}/A"
B_DIR="${RESULTS_DIR}/B"
LOG_DIR="${RESULTS_DIR}/logs"
