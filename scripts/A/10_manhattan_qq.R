args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
  stop("Usage: Rscript 10_manhattan_qq.R <assoc_linear_tsv> <out_prefix> <title>")
}

infile <- args[1]
out_prefix <- args[2]
main_title <- args[3]

d <- read.table(infile, header = TRUE, sep = "", stringsAsFactors = FALSE)
# Keep only additive model TEST=="ADD" (PLINK --linear output)
if ("TEST" %in% names(d)) d <- d[d$TEST == "ADD", ]

needed <- c("CHR","BP","SNP","P")
missing <- setdiff(needed, names(d))
if (length(missing) > 0) stop(paste("Missing columns:", paste(missing, collapse=", ")))

# Clean P
d <- d[!is.na(d$P) & d$P > 0, ]
d$logp <- -log10(d$P)

# Order by chr/bp
d$CHR <- as.integer(d$CHR)
d <- d[order(d$CHR, d$BP), ]

# Build cumulative position for Manhattan
chr_lengths <- tapply(d$BP, d$CHR, max)
chr_offsets <- c(0, cumsum(chr_lengths))[1:length(chr_lengths)]
names(chr_offsets) <- names(chr_lengths)

d$cum_bp <- d$BP + chr_offsets[as.character(d$CHR)]

# Tick positions
chr_mid <- sapply(names(chr_lengths), function(ch) {
  ch <- as.integer(ch)
  start <- chr_offsets[as.character(ch)]
  start + chr_lengths[as.character(ch)]/2
})

# Manhattan
png(paste0(out_prefix, "_manhattan.png"), width=1400, height=700)
plot(d$cum_bp, d$logp, pch=16, cex=0.5,
     xlab="Chromosome", ylab="-log10(P)", main=main_title, xaxt="n")
axis(1, at=chr_mid, labels=names(chr_mid))
abline(h=-log10(5e-8), lty=2)  # genome-wide suggestive line
dev.off()

# QQ plot
o <- -log10(sort(d$P))
e <- -log10(ppoints(length(o)))

png(paste0(out_prefix, "_qq.png"), width=800, height=800)
plot(e, o, pch=16, cex=0.6, xlab="Expected -log10(P)", ylab="Observed -log10(P)",
     main=paste0("QQ Plot — ", main_title))
abline(0,1, lty=2)
dev.off()

cat("Wrote plots with prefix:", out_prefix, "\n")
