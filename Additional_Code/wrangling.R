iris %>% arrange(Sepal.Length) %>% slice(1:6)

testdat <- iris %>% select(Species, Petal.Width)

iris %>%
  group_by(Species) %>% 
  summarize(n = n(), Sepal.Width.Mean = mean(Sepal.Width), Sepal.Length.Mean = mean(Sepal.Length), Petal.Length.Mean = mean(Petal.Length), Petal.Width.Mean = mean(Petal.Width))

iris %>% 
  group_by(Species) %>% 
  summarise_all(c(mean, sd))