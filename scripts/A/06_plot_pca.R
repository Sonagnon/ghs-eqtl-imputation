args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop("Usage: Rscript 06_plot_pca.R <eigenvec> <out_png>")
}
ev <- read.table(args[1], header = FALSE)
# PLINK eigenvec: FID IID PC1 PC2 ...
colnames(ev)[1:4] <- c("FID","IID","PC1","PC2")

png(args[2], width = 900, height = 700)
plot(ev$PC1, ev$PC2, xlab="PC1", ylab="PC2", pch=16)
dev.off()

cat("Wrote:", args[2], "\n")
