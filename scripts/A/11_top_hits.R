args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
  stop("Usage: Rscript 11_top_hits.R <assoc_linear_tsv> <out_tsv> <n_top>")
}
infile <- args[1]
out <- args[2]
n_top <- as.integer(args[3])

d <- read.table(infile, header = TRUE, sep = "", stringsAsFactors = FALSE)

# Keep additive model only
if ("TEST" %in% names(d)) d <- d[d$TEST == "ADD", ]

# Required columns
needed <- c("CHR","BP","SNP","P")
miss <- setdiff(needed, names(d))
if (length(miss) > 0) stop(paste("Missing columns:", paste(miss, collapse=", ")))

# Optional effect columns in PLINK --linear output
cols <- intersect(c("CHR","BP","SNP","A1","TEST","NMISS","BETA","SE","STAT","P"), names(d))
d <- d[, cols, drop=FALSE]

# Clean p-values
d <- d[!is.na(d$P) & d$P > 0, ]
d <- d[order(d$P), ]

top <- head(d, n_top)
write.table(top, file=out, sep="\t", quote=FALSE, row.names=FALSE)

cat("Wrote:", out, "\n")
