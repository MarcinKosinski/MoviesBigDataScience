#ktos wybiera film i !
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

# no i rysujemy tylko taka macierz, gdzie jakos trzeba oznaczyc ten i-ty film
