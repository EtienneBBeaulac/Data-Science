library(parallel)
no_cores <- detectCores() - 1

cl <- makeCluster(no_cores)

# load libraries
library(tidyverse)
clusterEvalQ(cl, library(tidyverse))

# devtools::install_github("hathawayj/buildings")
library(buildings) # remember that the 'permits' data object is created when the library is loaded.
a <- 4
ff <- function(x){
  for (i in 1:1000){
    i
  }
  x^3
}

clusterExport(cl, varlist = c("a", "ff", "permits"))


list_object <- as.list(1:1000000)

system.time(lapply(list_object, ff))
system.time(parLapply(cl,list_object, ff))

temp1 <- lapply(list_object, ff)
temp2 <- parLapply(cl, list_object, ff)

