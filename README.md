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
