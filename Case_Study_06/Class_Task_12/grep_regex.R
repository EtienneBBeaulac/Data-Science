library(ggplot2)
library(tidyverse)
library(dplyr)
library(readr)
library(stringr)

let <- read_lines("https://byuistats.github.io/M335/data/randomletters.txt")
let_nums <- read_lines("https://byuistats.github.io/M335/data/randomletters_wnumbers.txt")

match <- str_view(let, ".{1699}.*?\\K.")

nums <- str_extract_all(let_nums, '\\d+')
for (num in nums){
  print(letters[as.numeric(num)])
}

longest_seq <- sapply(str_extract_all(let, "[aeiou]+"), function(x) x[which.max(nchar(x))])
