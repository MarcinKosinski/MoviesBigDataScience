i <- 350



n<-5
returnFamiliar <- function( matrixInput, n, i){
# mamy dla niego najbardziej podobne filmy
which( matrixInput[i,] > 0 ) -> numerki_podobnych
closest <- order(matrixInput[i,numerki_podobnych])[1:n]
numerki_podobnych[closest] -> n_najblizszych_do_i

matrix(0,n,n) -> pomocnicza
for(j in n_najblizszych_do_i){
  which( moviesInfo[j,] > 0 ) -> numerki_podobnych
  
closest <- order(matrixInput[j,numerki_podobnych])[1:n]
numerki_podobnych[closest] -> n_najblizszych_do_j
pomocnicza[j,] <- n_najblizszych_do_j

}


matrixInput[ c(i,n_najblizszych_do_i, unique(as.vector(pomocnicza))),
            c(i,n_najblizszych_do_i, unique(as.vector(pomocnicza)))] -> podobne_do_i

return(podobne_do_i)
}

returnFamiliar(moviesInfo) -> podobne_do_i 
mm <- as.matrix(podobne_do_i)

library(reshape)
#zamieniam na postac kolumnowa 
mmr <-  melt(mm)[melt(upper.tri(mm))$value,]
#sorutje po X1 X2
mmr <- mmr[order(mmr[,1],mmr[,2]),]
mmr2 <- mmr[mmr[, 3]>0,] 
nazwy <- unique(sort(c(as.character(mmr2[,1]),as.character(mmr2[,2]))))
# numery wezlow musza byc od 0(zamieniam to tak)
mmr2[, 1] <- as.integer(as.factor(mmr2[, 1]))-1
mmr2[, 2] <- as.integer(as.factor(mmr2[, 2]))-1
#mmr2[, 3] <- log(mmr2[, 3])
mmr2[, 3] <- max(mmr2[, 3])/(mmr2[, 3])

#mmr2 <- mmr[mmr[, 3]>0,] 
names(mmr2) <- c('source', 'target', 'value')
#nazwy <- unique(sort(c(rownames(mm),colnames(mm))))
grupy <- as.integer(rownames(moviesInfo)[i]==nazwy)
mmrNodes <- data.frame(name=nazwy, group=grupy)

library(networkD3)
forceNetwork(Links=mmr2, Nodes=mmrNodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 0.9)
