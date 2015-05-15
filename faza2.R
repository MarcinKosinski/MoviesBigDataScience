library(tm)


strsplit_comma_tokenizer <- function(x)
   unlist(strsplit(as.character(x), ",[ ]"))

c<-Corpus(VectorSource(filmy$lang))
x<-DocumentTermMatrix(c, control = list(tokenize=strsplit_comma_tokenizer))


dim(x)

names(filmy)



