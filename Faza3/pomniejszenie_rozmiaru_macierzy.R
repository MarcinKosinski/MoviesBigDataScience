# pomniejszanie zbiorow danych
load("Faza3/moviesInfoDist.rda")
#Wyciagniecie filmow z bazy danych
load("Faza1/haslo.rda")

library(RMySQL)

# ładujemy sterownik do bazy danych
sterownik <- MySQL()

# aby się połączyć musimy podać użytkownika, hasło i wskazać bazę danych
# inicjujemy połączenie z serwerem bazodanowym
mpolaczenie = dbConnect(sterownik, 
                        user='pbiecek', password=haslo, dbname='students', 
                        host='beta.icm.edu.pl')


dbListTables(mpolaczenie)
dbGetQuery(mpolaczenie, "SELECT count(*) 
           FROM Grabarz_Kosinski_Wasniewski")
# count(*)
# 1     9334



# pobranie wszystkich filmow
movies <- dbGetQuery(mpolaczenie, "SELECT * 
                     FROM Grabarz_Kosinski_Wasniewski")

# tytuly
titles <- movies$title


removeDuplicatedMovies <- function(distObject, titles){
   distObject <- as.matrix(distObject)
   
   colnames(distObject) <- titles
   rownames(distObject) <- titles
   
#    temp <- distObject[1:50,1:50]
#    heatmap(temp, symm=TRUE)
   
   i <- !duplicated(titles)
   distObject <- distObject[i, i]
   return( distObject )
}

removeDuplicatedMovies(moviesInfoDist, titles) -> moviesInfoDist_noDups



#pozostaw 20 najblizszych filmow

leaveClosest <- function( matrixInput, n ){
   
   pb <- txtProgressBar(min = 0, max = nrow(matrixInput), style = 3)
   for(i in 1:nrow(matrixInput)){
      
      # wybor indeksow n najblizszych filmow
      closest <- order(matrixInput[i,])[1:(n+1)]
      
      matrixInput[i,-closest] <- 0
      
      # update progress bar
      setTxtProgressBar(pb, i)
   }
   close(pb)
   
   return(matrixInput)
   
}

leaveClosest( moviesInfoDist_noDups, 20 ) -> moviesInfoDist_noDups_closest

#przejscie na postac rzadka
library(Matrix)
Matrix(moviesInfoDist_noDups_closest, sparse = TRUE) -> moviesInfo
save(moviesInfo, file = "Faza3/moviesInfo.rda")

