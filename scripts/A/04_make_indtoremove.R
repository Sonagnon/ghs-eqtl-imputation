args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
  stop("Usage: Rscript 04_make_indtoremove.R <het_file> <genome_file> <out_file>")
}

het_file <- args[1]
genome_file <- args[2]
out_file <- args[3]

# --- Heterozygosity outliers ---
het <- read.table(het_file, header = TRUE)
# PLINK .het typically has columns: FID IID O(HOM) E(HOM) N(NM) F
if (!all(c("FID","IID","F") %in% colnames(het))) {
  stop("Unexpected .het format: missing FID/IID/F columns")
}

mu <- mean(het$F, na.rm = TRUE)
sdv <- sd(het$F, na.rm = TRUE)
low <- mu - 3*sdv
high <- mu + 3*sdv

het_out <- het[het$F < low | het$F > high, c("FID","IID")]
het_out$reason <- "HET_OUTLIER"

# --- Relatedness outliers ---
gen <- read.table(genome_file, header = TRUE)
# PLINK .genome has columns: FID1 IID1 FID2 IID2 PI_HAT ...
needed <- c("FID1","IID1","FID2","IID2","PI_HAT")
if (!all(needed %in% colnames(gen))) {
  stop("Unexpected .genome format: missing required columns")
}

rel_pairs <- gen[!is.na(gen$PI_HAT) & gen$PI_HAT > 0.185, c("FID1","IID1","FID2","IID2","PI_HAT")]

# Simple strategy: remove the second individual in each related pair
rel_out <- rel_pairs[, c("FID2","IID2")]
colnames(rel_out) <- c("FID","IID")
rel_out$reason <- "RELATED_PIHAT_GT_0.185"

# --- Merge and write unique list ---
out <- unique(rbind(het_out[,c("FID","IID","reason")], rel_out[,c("FID","IID","reason")]))
write.table(out[,c("FID","IID")], file = out_file, quote = FALSE, row.names = FALSE, col.names = FALSE, sep = "\t")

# Also write a report with reasons
report_file <- sub("\\.txt$", "_report.tsv", out_file)
write.table(out, file = report_file, quote = FALSE, row.names = FALSE, sep = "\t")

cat("Wrote:\n")
cat("-", out_file, "\n")
cat("-", report_file, "\n")
cat("Counts:\n")
cat("  HET outliers:", nrow(het_out), "\n")
cat("  Related removals:", nrow(rel_out), "\n")
cat("  Total unique:", nrow(out), "\n")
