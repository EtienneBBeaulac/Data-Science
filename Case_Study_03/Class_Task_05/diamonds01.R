diamonds %>% 
  filter(price < 2000) %>% 
  # mutate(size = (x + y + z)) +
  ggplot() +
  geom_point(aes(x = carat, y = price, shape = cut, color = color, size = table, alpha = clarity)) +
  ggsave('diamonds01.png', width = 15)
