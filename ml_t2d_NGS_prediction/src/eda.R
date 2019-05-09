### islets EDA

setwd('/ds/ML/aging/islet/results')
savehistory('islet-all.Rhistory')
savehistory('islet.Rhistory')
file.append('islet-all.Rhistory', 'islet.Rhistory')

library(Rtsne)
library(mclust)

#### preprocess ####
## read exp rpkm data
df <- read.delim('../data/GSE81608_human_islets_rpkm.txt', header = T, stringsAsFactors = F)
data <- df[,-1]
## read sample annotation
info <- read.delim('../data/GSE81608_series_matrix.txt', skip=28, stringsAsFactors = F)
info <- info[,-1] # remove row annotation, with duplicate so not as rownames
names(info) = names(data)
t2d <- as.character(info[11,])
cell.type <- as.character(info[15,])

## filter rpkm, remove gene with too many missing values, t-SNE, PCA
train <- data[rowSums(data>100)>10,] # 6000 * 1600 
tsne <- Rtsne(t(train), dims = 2, perplexity=30, verbose=TRUE, max_iter = 300) # iter change results significantlly 

pca <- prcomp(t(train))
## Plotting
colors = rainbow(length(unique(cell.type)))
names(colors) = unique(cell.type)
par(mfrow=c(1,2))
plot(tsne$Y, main="tsne", pch = as.numeric(as.factor(t2d)), col=colors[cell.type])
plot(pca$x[, 1:2], main= 'pca', pch = as.numeric(as.factor(t2d)), col=colors[cell.type])
dev.copy2pdf(file='tsne-pca-t2d-cellType.pdf', width=8, height=4)

#### filter beta cell samples, highly expressed genes ####
names(info)= names(data)
beta <- data[, info[15,]=='cell subtype: beta']
beta.t2d <- info[11, info[15,]=='cell subtype: beta']
beta.high <- beta[rowSums(beta>100)>10,]
## log transform
beta.high.log <- log(beta.high+1)    
beta.tsne <- Rtsne(t(beta.high.log), dims = 2, perplexity=30, verbose=TRUE, max_iter = 1000)
plot(beta.tsne$Y, ylim= c(-15, 20),main= 'tsne', col = as.numeric(as.factor(as.character(beta.t2d))))
dev.copy2pdf(file='betaCell-tsne-iter1000-log.pdf')
beta.t2d[beta.t2d=='condition: non-diabetic']<- 0
beta.t2d[beta.t2d=='condition: T2D']<- 1

## pca top 500 gene to ml
beta.pca <- prcomp(t(beta.high.log))
plot(beta.pca$x[, 1:2], main= 'pca', col = as.numeric(as.factor(as.character(beta.t2d))))
dev.copy2pdf(file='betaCell-pca-log.pdf')
beta.tsne <- Rtsne(t(beta.high.log), dims = 2, perplexity=30, verbose=TRUE, max_iter = 300)
beta.loading <- as.data.frame(beta.pca$rotation)
beta.top500.label <- rownames(beta.loading[order(beta.loading$PC1, decreasing = T),])[1:500]
beta.top500 <- beta.high.log[beta.top500.label,]
for.ml <- t(rbind(beta.t2d, beta.top500))
colnames(for.ml)[1]='t2d'
write.csv(for.ml, file='betaCell-top500pcaGene.csv', quote=F, row.names = F)

#### filter alpha cell samples, highly expressed genes ####
alpha <- data[, info[15,]=='cell subtype: alpha']
alpha.t2d <- info[11, info[15,]=='cell subtype: alpha']
alpha.high <- alpha[rowSums(alpha>100)>10,]
## log transform
alpha.high.log <- log(alpha.high+1)    
alpha.tsne <- Rtsne(t(alpha.high.log), dims = 2, perplexity=30, verbose=TRUE, max_iter = 1000)
plot(alpha.tsne$Y, ylim= c(-15, 20),main= 'tsne', col = as.numeric(as.factor(as.character(alpha.t2d))))
dev.copy2pdf(file='alphaCell-tsne-iter1000-log.pdf')
alpha.t2d[alpha.t2d=='condition: non-diabetic']<- 0
alpha.t2d[alpha.t2d=='condition: T2D']<- 1

#### pca top 500 gene to ml
alpha.pca <- prcomp(t(alpha.high.log))
plot(alpha.pca$x[, 1:2], main= 'pca', col = as.numeric(as.factor(as.character(alpha.t2d))))
dev.copy2pdf(file='alphaCell-pca-log.pdf')
alpha.tsne <- Rtsne(t(alpha.high.log), dims = 2, perplexity=30, verbose=TRUE, max_iter = 300)
alpha.loading <- as.data.frame(alpha.pca$rotation)
alpha.top500.label <- rownames(alpha.loading[order(alpha.loading$PC1, decreasing = T),])[1:500]
alpha.top500 <- alpha.high.log[alpha.top500.label,]
for.ml <- t(rbind(alpha.t2d, alpha.top500))
colnames(for.ml)[1]='t2d'
write.csv(for.ml, file='alphaCell-top500pcaGene.csv', quote=F, row.names = F)

#### wilcoxon top 500 genes
pvals <- apply(alpha.high,1,function(x) {wilcox.test(x[1:377],x[378:length(alpha.high)])$p.value})
## FDR 
fdr <- p.adjust(pvals, method='fdr')
alpha.wilcox.label <- as.numeric(names(fdr[order(fdr,decreasing = F)]))[1:500]
alpha.wilcox <- alpha.high.log[ rownames(alpha.high.log) %in% alpha.wilcox.label,]
#library(magrittr)
tmp <- t(rbind(alpha.t2d, alpha.wilcox)) 
colnames(tmp)[1]='t2d'
write.csv(tmp, file='alphaCell-top500wilcoxGene.csv', quote=F, row.names = F)

