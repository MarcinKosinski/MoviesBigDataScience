i <- 350

# mamy dla niego najbardziej podobne filmy
which( moviesInfo[i,] > 0 ) -> numerki_podobnych

n<-5
sapply(1:n, function(element){
  which( element == order(moviesInfo[i,numerki_podobnych]))
}) -> najblizsze_n



# dla najblizszych tez bierzemy 5 najbardziej podobnych
sapply(numerki_podobnych[najblizsze_n], function(element){
  numerki_podobnych_2 <- which( moviesInfo[element,] > 0 )
  sapply(1:n, function(element2){
    which( element2  == order(moviesInfo[element,numerki_podobnych_2]))
  }
  ) -> x_numerki
  numerki_podobnych_2[x_numerki]
  
}
) -> numeraski
unique(as.vector(numeraski)) -> numeraski2

moviesInfo[ c(i,numerki_podobnych[najblizsze_n], numeraski2),
            c(i,numerki_podobnych[najblizsze_n], numeraski2)] -> podobne_do_i



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
