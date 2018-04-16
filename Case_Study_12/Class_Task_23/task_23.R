library(ggplot2)
library(tidyverse)
library(dplyr)
library(readr)
library(stringr)

let_nums <- read_lines("https://byuistats.github.io/M335/data/randomletters_wnumbers.txt")
let <- read_lines("https://byuistats.github.io/M335/data/randomletters.txt")

extract_secret_message <- function(text) {
  empty_string <- ""
  nums <- str_extract_all(text, '\\d+')
  for (num in nums){
    empty_string <- paste(empty_string, letters[as.numeric(num)], sep = "")
  }
  return(paste(empty_string, collapse = ""))
}

extract_secret_message(let_nums)

find_longest_sequence <- function(text, type) {
  longest_seq <- "ERROR: Incompatible type"
  if (type == "vowel") {
    longest_seq <- sapply(str_extract_all(text, "[aeiou]+"), function(x) x[which.max(nchar(x))])
  } else if (type == "consonant") {
    longest_seq <- sapply(str_extract_all(text, "[^aeiou\\s\\d\\X\\[.,\\/#!$%\\^&\\*;:{}=\\-_`~()]+"), function(x) x[which.max(nchar(x))])
  } else if (type == "punctuation") {
    longest_seq <- sapply(str_extract_all(text, "[\\[.,\\/#!$%\\^&\\*;:{}=\\-_`~()]+"), function(x) x[which.max(nchar(x))])
  }
  return(longest_seq)
}

find_longest_sequence(let, "consonant")

reverse_string <- function(text) {
  text <- sapply(lapply(strsplit(text, NULL), rev), paste, collapse = "")
  return(text)
}

reverse_string("This is a test")

reverse_words <- function(text) {de
  text <- strsplit(text, " +")
  text <- paste(reverse_string(text[[1]]), collapse = " ")
  return(text)
}

reverse_words("I'll try to do this tomorrow")


get_data_from_zip <- function(path, mode="wb") {
  df <- file_temp() 
  uf <- path_temp("zip") 
  download(path, df, mode = mode)  
  unzip(df, exdir = uf) 
  dat <- read_sf(uf) 
  file_delete(df) 
  dir_delete(uf)
  return(dat)
}
