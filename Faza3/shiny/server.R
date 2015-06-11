library(shiny)
library(stringi)
library(reshape)
library(networkD3)
library(htmlwidgets)
library(reshape)

load("data/movies.rda")
load("data/moviesInfo.rda")

load("data/keywords.rda")
load("data/people.rda")


returnFamiliar <- function( matrixInput, n, k, i){
   
   # mamy dla niego najbardziej podobne filmy
   which( matrixInput[i,] > 0 ) -> numerki_podobnych
   closest <- order(matrixInput[i,numerki_podobnych])[1:n]
   numerki_podobnych[closest] -> n_najblizszych_do_i
   
   matrix(0,n,k) -> pomocnicza
   kk<-0
   for(j in n_najblizszych_do_i){
      kk <- kk+1
      which( matrixInput[j,] > 0 ) -> numerki_podobnych
      
      closest <- order(matrixInput[j,numerki_podobnych])[1:k]
      numerki_podobnych[closest] -> n_najblizszych_do_j
      pomocnicza[kk,] <- n_najblizszych_do_j
      
   }
   
   
   matrixInput[ c(i,n_najblizszych_do_i, unique(as.vector(pomocnicza))),
                c(i,n_najblizszych_do_i, unique(as.vector(pomocnicza)))] -> podobne_do_i
   
   return(podobne_do_i)
}


shinyServer(function(input,output){
   
   # informacje o filmie
   output$info <- renderTable({
      movies[movies$title==input$movie, 2:10]
   })
   output$cast <- renderText({
      actors <- unlist(stri_split_fixed(movies[movies$title==input$movie, "cast"],", "))
      if (length(actors)>20){
         actors <- actors[1:20]
      }
      stri_paste(actors, "\n")
      #movies[input$movie, "cast"]
   })
   
   output$director <- renderText({
      movies[movies$title==input$movie, "director"]
   })
   
   output$writers <- renderText({
      movies[movies$title==input$movie, "writers"]
   })
   
   ### podobne filmy:
   
   
   output$podobne_lista <- renderText({
      n<-20-as.numeric(input$liczba_filmow)+1
      if (input$preferencje=="ogolnie") {
         i <- which(rownames(moviesInfo)==input$movie)
         podobne_filmy<-names(sort(moviesInfo[i, ],
                                   decreasing=TRUE)[20:n])
         stri_paste(podobne_filmy, "\n")
      } else if (input$preferencje=="fabula") {
         i <- which(rownames(keywords)==input$movie)
         # trzeba pĂłĹşniej zminic macierz bo narzaie wszedzie jest ta sama
         podobne_filmy<-names(sort(keywords[i, ], 
                                   decreasing=TRUE)[20:n])
         stri_paste(podobne_filmy, "\n") 
      } else { 
         i <- which(rownames(people)==input$movie)
         podobne_filmy<-names(sort(people[i, ],
                                   decreasing=TRUE)[20:n])
         stri_paste(podobne_filmy, "\n") 
      }
   })
   
   
   
   
   output$graph <- renderForceNetwork({
      n <- as.numeric(input$liczba_filmow)
      k <- as.numeric(input$ile_podobnych_do_najpodobniejszych)
      if(input$preferencje=="ogolnie"){
         moviesInfo -> moviesInfo2
         
      }
      if(input$preferencje=="fabula"){
         keywords -> moviesInfo2
      }
      if(input$preferencje=="obsada"){
         people -> moviesInfo2
      }
      i <- which(rownames(moviesInfo2)==input$movie)
      
      returnFamiliar(moviesInfo2,n,k,i) -> podobne_do_i 
      
      #nazwy <- unique(sort(c(rownames(mm),colnames(mm))))
      
      mm <- as.matrix(podobne_do_i)
      
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
      #grupy <- as.integer(rownames(moviesInfo2)[i]==nazwy)
      #mmrNodes <- data.frame(name=nazwy, group=grupy)
      
      name_genre <- movies[,c('title','genre')][!duplicated(movies$title),]
      name_genre$genre <- stri_extract_first_regex(name_genre$genre,'\\p{l}*')
      
      mmrNodes2 <- name_genre[name_genre$title %in% nazwy,]
      mmrNodes2 <- mmrNodes2[order(mmrNodes2$title),]
      mmrNodes2$genre[rownames(moviesInfo2)[i]==mmrNodes2$title] <- 'aaa'
      rownames(mmrNodes2) <- NULL
      names(mmrNodes2) <- c('name', 'group')
      
      forceNetwork(Links=mmr2, Nodes=mmrNodes2, Source = "source",
                   Target = "target", Value = "value", NodeID = "name",
                   Group = "group", opacity = 0.9, linkWidth=1,
                   linkDistance=JS('function(d) {', paste('return d.value *', input$odleglosc,';'), '}'))
      
      
   }
   )
   
   
   
   
})
#,
#linkDistance=JS('function(d) {', paste('return d.value *', input$odleglosc,';'), '}')
