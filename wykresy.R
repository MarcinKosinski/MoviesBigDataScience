#

load("haslo.rda")

library(RMySQL)

# ładujemy sterownik do bazy danych
sterownik <- MySQL()

# aby się połączyć musimy podać użytkownika, hasło i wskazać bazę danych
# inicjujemy połączenie z serwerem bazodanowym
mpolaczenie = dbConnect(sterownik, 
                        user='pbiecek', password=haslo, dbname='students', 
                        host='beta.icm.edu.pl')


dbReadTable(mpolaczenie, "Grabarz_Kosinski_Wasniewski") -> x

library(ggthemes)
library(ggplot2)
library(dplyr)
library(stringi)
x$genre %>% 
   stri_split( fixed = ",") %>% 
   unlist %>% 
   stri_extract_all_words() %>%
   unlist %>%
   table %>% 
   as.data.frame() -> freguencyTable



names(freguencyTable)[1] <- "genre"
freguencyTable %>%
   mutate( genre = factor(genre, levels(genre)[order(Freq)] )) %>%
   ggplot( aes( x = genre , y = Freq)) +
   geom_bar(stat="identity") +
   coord_flip() +theme_wsj() +ggtitle("Rozkład typów filmów w bazie")


x %>%
   filter( budget < 1.0e+08) %>%
   mutate( rating = as.numeric(as.character(rating))) %>%
   ggplot( aes( x = budget, y = rating)) +
   geom_point() + geom_smooth() + theme_wsj() +ggtitle("Budżet a ocena filmu \n budżet < 10^8")



x %>%
   mutate( rating = as.numeric(as.character(rating))) %>%
   ggplot( aes( x = log(budget+1), y = rating)) +
   geom_point() + geom_smooth() + theme_wsj() +ggtitle("log(Budżet) a ocena filmu")

