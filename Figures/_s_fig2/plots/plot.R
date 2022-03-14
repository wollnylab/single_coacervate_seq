library(DescTools)
library(RColorBrewer)

pairedd<-paired_merge_TPM
rownames(pairedd)<-paired_merge_TPM$Biotype
pairedd<-pairedd[ , -1]
names(pairedd)<-c("Droplet RNA", "Input RNA", "Negative control")
pairedd<-as.matrix(pairedd)
pairedd[is.na(pairedd)]<-0
pairedd<-(pairedd/1000000) * 100
pairedd<-pairedd[ , -3]
barplot(pairedd, beside=FALSE, col=brewer.pal(nrow(pairedd), "Paired"), ylim = c(0, 100), xlim = c(0.2, 3.3),
        ylab="TPM %",
        legend.text=TRUE,
        args.legend=list(
          x=ncol(pairedd) + 2.1,
          y=max(colSums(pairedd)),
          bty = "n"
        )
)

ConnLines(pairedd, beside=FALSE, lcol="grey50", lwd=3, lty=1)
