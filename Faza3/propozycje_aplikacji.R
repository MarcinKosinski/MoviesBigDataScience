#ktos wybiera film i !
   i <- 150

# mamy dla niego najbardziej podobne filmy
which( moviesInfo[150,] > 0 ) -> numerki_podobnych

# i teraz pomniejszamy zbior biora tylko te wiersze i kolumy



moviesInfo[ numerki_podobnych, numerki_podobnych] -> podobne_do_i

# no i rysujemy tylko taka macierz, gdzie jakos trzeba oznaczyc ten i-ty film
