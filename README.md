# GHS — Projet GENOM (A: QC+GWAS, B: Phasing+Imputation)

Projet académique basé sur la cohorte Gutenberg Health Study (GHS) : nettoyage QC des génotypes,
détection d’outliers (homogénéité génétique), GWAS sur phénotypes quantitatifs (HDL, ApoA1),
puis phasage + imputation (panel 1000 Genomes Phase 3) et GWAS sur génotypes imputés.

## Projets
### Projet A — QC + homogénéité + GWAS
1. QC des SNPs (filtrage)
2. Homogénéité / outliers (matrices de distance, PCA/MDS)
3. Génération de jeux de données "propres"
4. Association (PLINK) sur HDL et ApoA1 + plots (Manhattan, QQ)

### Projet B — Phasage + imputation + (optionnel) GWAS imputée
1. Reprendre les sorties "propres" du Projet A
2. Phasage (ex: SHAPEIT / Mach)
3. Imputation (ex: Minimac / Impute2)
4. (Optionnel) Association sur génotypes imputés (ex: Mach2qtl)

## Organisation du repo
- scripts/A : pipeline Projet A
- scripts/B : pipeline Projet B
- data : données (non versionnées)
- results : résultats (non versionnés)
- docs : énoncé PDF et notes

## Données attendues (non fournies)
### Génotypes (PLINK)
Placer dans `data/raw/genotypes/` :
- chr2.{bed,bim,fam}
- chr5.{bed,bim,fam}
- chr13.{bed,bim,fam}
- chr16.{bed,bim,fam}

### Phénotypes
Placer dans `data/raw/phenotypes/phenotype_plink.txt`
Contient les identifiants + phénotypes quantitatifs HDL et ApoA1.

### Covariables (optionnel)
Placer dans `data/raw/covariates/covar_plink.txt`
Exemples: âge, sexe, BMI...

### Panel de référence (Projet B)
Placer dans `data/reference/1000G_phase3/` (européen, chr2/5/13/16).

## Exécution (à venir)
Les scripts seront ajoutés progressivement dans l’ordre du pipeline.

## Exécution — Projet A (QC + homogénéité + GWAS + plots)

### 0) Vérification des inputs
```bash
bash scripts/A/01_check_inputs.sh

1) QC SNPs (par chromosome)
bash scripts/A/02_qc_snps.sh
2) QC individus (missingness + het + IBD) + indtoremove
bash scripts/A/03_qc_individuals.sh

Rscript scripts/A/04_make_indtoremove.R \
  results/A/qc_individuals/chr2_het.het \
  results/A/qc_individuals/chr2_ibd.genome \
  results/A/qc_individuals/indtoremove.txt

2bis) PCA (structure) + plot PC1/PC2
bash scripts/A/05_pca_outliers.sh
Rscript scripts/A/06_plot_pca.R results/A/pca/chr2_pca.eigenvec results/A/pca/chr2_pca_PC1_PC2.png

3) Générer les datasets propres (par chromosome)
bash scripts/A/07_make_clean_data.sh
4) GWAS (HDL_CHOL, ApoA1) — unadjusted + covariates si dispo
bash scripts/A/08_gwas_plink.sh
5) Fusion des résultats + Manhattan/QQ
bash scripts/A/09_merge_gwas_results.sh

Rscript scripts/A/10_manhattan_qq.R \
  results/A/gwas_merged/HDL_CHOL_unadj.assoc.linear.tsv \
  results/A/plots/HDL_CHOL_unadj \
  "GHS Project A — HDL_CHOL (unadjusted)"

6) Top hits (tables)
Rscript scripts/A/11_top_hits.R \
  results/A/gwas_merged/HDL_CHOL_unadj.assoc.linear.tsv \
  results/A/tables/top20_HDL_CHOL_unadj.tsv 20

Outputs (Projet A)

Datasets filtrés SNP: results/A/qc_snps/

QC individus + listes: results/A/qc_individuals/

PCA: results/A/pca/

Datasets propres finaux: results/A/clean/

GWAS par chromosome: results/A/gwas/

GWAS fusionnés: results/A/gwas_merged/

Plots: results/A/plots/ (Manhattan + QQ)

Tables: results/A/tables/ (top hits)
