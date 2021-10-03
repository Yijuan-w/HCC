library(igraph)

#setwd("d:\\A\\work\\Rcode")

#getwd()
relationship<- read.csv("5cancernetleft1.4.csv",header=T,row.names = 1)

g2 <- graph_from_data_frame(relationship[1:2], directed=F)
plot(g2,layout=layout.fruchterman.reingold)

l<-mean_distance(g2,normalized = T)
pl<-shortest.paths(g2)
pl[sapply(pl,is.infinite)]<-NA

for (i in 1:108) {
  
  N=107 - sum(is.na(pl[i,]))
  q=sum(pl[i,],na.rm = T)
  pathlength[i]=q*2/(N*(N+1))
  
}

d <-  degree(g2)
genesymbol<-names(d)
d2<-data.frame(d,genesymbol)
dorder<-d2[order(d2$d,decreasing = T),]#1
cc <- transitivity(g2, type="local")
cc2<-data.frame(cc,genesymbol)
cc2[order(cc2$cc,decreasing = T),]
bc <-  betweenness(g2,normalized = T)
bc2<-data.frame(bc,genesymbol)
bcorder<- bc2[order(bc2$bc,decreasing = T),]#2

d[2]<-names(d)

write.csv(pathlength,"meanpl.csv")
write.csv(bc,"bc1.csv")
write.csv(cc,"cc1.csv")
write.csv(d,"degree1.csv")
write.table(d,file = 'dgree.txt',sep = ' ')


library(RankAggreg)
library(centiserve)

lincent<-lincent(g2) 
lincent2<-data.frame(lincent,genesymbol)
lincentorder<-lincent2[order(lincent2$incent,decreasing = T),]
write.csv(lincent,"lincent1.csv")

closeness.residual<-closeness.residual(g2)
closeness.residual2<-data.frame(closeness.residual,genesymbol)#3
closeness.residualorder<-closeness.residual2[order(closeness.residual2$closeness.residual,decreasing = T),]

write.csv(closeness.residual,"closenessresidual1.csv")


closeness.latora<-closeness.latora(g2)
write.csv(closeness.latora,"closenesslatora1.csv")

laplacian<-laplacian(g2) 
laplacian2<-data.frame(laplacian,genesymbol)
laplacianorder<-laplacian2[order(laplacian2$laplacian,decreasing = T),]
write.csv(laplacian,"laplacian1.csv")

geokpath<-geokpath(g2)

write.csv(geokpath,"geokpath1.csv")

semilocal<-semilocal(g2) 
semilocal2<-data.frame(semilocal,genesymbol)
semilocalorder<-semilocal2[order(semilocal2$semilocal,decreasing = T),]
write.csv(semilocal,"semilocal1.csv")

diffusion.degree<-diffusion.degree(g2)
diffusion.degree2<-data.frame(diffusion.degree,genesymbol
diffusion.degreeorder<-laplacian2[order(diffusion.degree2$diffusion.degree,decreasing = T),]

write.csv(diffusion.degree,"diffusiondegree1.csv")
markovcent<-markovcent(g2)


library(linkcomm)
communitycen<-communitycent(g2)
write.csv(communitycen,"communitycent1.csv")
g3 <- graph_from_data_frame
g3 <- graph_from_data_frame(relationship[1:2], directed=T)

leaderRank<-leaderrank(g3, vids = V(g3))
leaderRank2<-data.frame(leaderRank,genesymbol)
leaderRank2[order(leaderRank2$leaderRank,decreasing = T),]
leaderrankorder<-leaderRank2[order(leaderRank2$leaderRank,decreasing = T),]
finaldataframe<-data.frame(dorder$genesymbol,bcorder$genesymbol,closeness.residualorder$genesymbol,laplacianorder$genesymbol,leaderrankorder$genesymbol)

# rank aggregation without weights
x <- matrix(c("A", "B", "C", "D", "E",
              "B", "D", "A", "E", "C",
              "B", "A", "E", "C", "D",
              "A", "D", "B", "C", "E"), byrow=TRUE, ncol=5)

(CESnoweights <- RankAggreg(x, 5, method="CE", distance="Spearman", N=100, convIn=5, rho=.1))

# weighted rank aggregation
set.seed(100)
w <- matrix(rnorm(20), ncol=5)
w <- t(apply(w, 1, sort))

# using the Cross-Entropy Monte-Carlo algorithm
(CES <- RankAggreg(x, 5, w, "CE", "Spearman", rho=.1, N=100, convIn=5))
plot(CES)
(CEK <- RankAggreg(x, 5, w, "CE", "Kendall", rho=.1, N=100, convIn=5))

# using the Genetic algorithm
(GAS <- RankAggreg(x, 5, w, "GA", "Spearman"))
plot(GAS)
(GAK <- RankAggreg(x, 5, w, "GA", "Kendall"))

# more complex example (to get a better solution, increase maxIter)
data(geneLists)
list=t(finaldataframe)
topGenes <- RankAggreg(list, 50, method="GA", maxIter=20000)
plot(topGenes)
list <- topGenes$top.list
write.csv(list,"top50.csv")
write.csv(finaldataframe,"finaldataframe.csv")