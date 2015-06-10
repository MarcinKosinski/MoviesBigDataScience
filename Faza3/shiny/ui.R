library(shiny)

load("data/movies.rda")

tytul <- 1:nrow(movies)
names(tytul) <- movies$title
# przy tych filmach robi sie jakis blad w select input  
j<-which(stri_detect_regex(movies$title, "\\032"))

shinyUI(fluidPage(
   titlePanel("Projekt filmy"),
   sidebarLayout(sidebarPanel("",
          # wybór filmu
         selectInput("movie","Wybierz film:",tytul[-j], 13),
         # wybór preferencji
         radioButtons("preferencje",
                     "Wybierz preferencje dla podobych filmĂłw:",
                     c("obsada"="obsada", "fabuĹ‚a"="fabula", 
                       "ogĂłlnie"="ogolnie")),
         # wybór liczby podobnych filmów 
         selectInput("liczba_filmow",
                     "Wybierz liczbe podobnych filmĂłw:",5:20, 10)
         ),
      mainPanel("",
            tabsetPanel(
            tabPanel("Informacje o filmie",
                     p(""),
                     tableOutput("info"),
                     p("ReĹĽyseria:"),
                     verbatimTextOutput("director"),
                     p("Scenariusz:"),
                     verbatimTextOutput("writers"),
                     p("GĹ‚Ăłwni aktorzy:"),
                     verbatimTextOutput("cast")
                     ),
            tabPanel("Podobne filmy",
                     p("Lista podobnych filmĂłw:"),
                     verbatimTextOutput("podobne_lista"),
                     p("Graf podobnych filmĂłw:"),
                     forceNetworkOutput("graph")
            )
            
         )
         )
      )
   ))




