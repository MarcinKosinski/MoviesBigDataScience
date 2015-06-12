library(shiny)
library(stringi)
library(reshape)
library(networkD3)
library(htmlwidgets)
library(reshape)

load("data/movies.rda")

tytul <- 1:nrow(movies)
 # names(tytul) <- movies$title
# przy tych filmach robi sie jakis blad w select input  
#j <- which(stri_detect_regex(movies$title, "\\032"))
names(tytul) <- stri_replace_all_regex(movies$title, "\\032", "")

tytul <- stri_replace_all_regex(movies$title, "\\032", "")

shinyUI(fluidPage(
   titlePanel("Serwis Rekomendujący Filmy"),
   sidebarLayout(sidebarPanel("",
          # wybór filmu
         selectInput("movie","Wybierz film:",tytul, "50 twarzy Greya"),
         # wybór preferencji
         radioButtons("preferencje",
                     "Wybierz preferencje dla podobych filmów:",
                     c("obsada i ekipa filmowa"="obsada", "Słowa kluczowe filmu"="fabula", 
                       "ogólne informacje o filmie"="ogolnie")),
         # wybór liczby podobnych filmów 
         selectInput("liczba_filmow",
                     "Wybierz liczbe podobnych filmów:",3:10, 5),
         
         selectInput("ile_podobnych_do_najpodobniejszych",
                     "Wybierz liczbe podobnych filmów do podobnych:",0:5, 2),
         sliderInput("odleglosc",
                     "Przemnoż odległości w grafie :",min=1,max=10, value = 50),
         h5("Autorzy serwisu: Marcin Kosiński, Mikołaj Waśniewski, Paweł Grabowski.")
         ),
         
         
      mainPanel("",
            tabsetPanel(
            tabPanel("Informacje o filmie",
                     p(""),
                     tableOutput("info"),
                     p("Reżyseria:"),
                     verbatimTextOutput("director"),
                     p("Scenariusz:"),
                     verbatimTextOutput("writers"),
                     p("Główni aktorzy:"),
                     verbatimTextOutput("cast")
                     ),
            tabPanel("Podobne filmy",
                     p("Lista podobnych filmów:"),
                     verbatimTextOutput("podobne_lista"),
                     p("Opis grafu:"),
                     h5("Każdzy wierzchołek grafu reprezentuje jeden film. Na grafie ciemnym niebieskim kolorem zaznaczony jest wybrany film. Dla danego filmu pokazana jest wybrana liczba filmów, które
                        są do niego najbardziej podobne. Długość krawędzi łącząca wierzchołki w grafie odpowiada podobieństwu filmów: im krótsza krawędź łącząca wierzchołki, tym filmy są bardziej do siebie 
                        podobne. Dla podobnych filmów do wybranego filmu, przedstawione są również filmy najbardziej podobne do nich. Dla tak wybranych sąsiadów sąsiadów, jeżeli pozostałe filmy są wśród 20 najbardziej
                        podobnych filmów do nich, to również są połączeni krawędzią, której długość odpowiada podobieństwu filmów. Kolory na grafie odpowiadają tematyce filmów. Jeżeli wierzchołki mają ten sam
                        kolor, to znaczy, że filmy, które odpowiadają wierzchołkom pochodzą z tej samej tematyki."),
                     p("Graf podobnych filmów:"),
                     forceNetworkOutput("graph")
                     
            )
            
         )
         )
      )
   ))




