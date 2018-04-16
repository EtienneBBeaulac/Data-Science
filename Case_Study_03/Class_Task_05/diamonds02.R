data <- transform(diamonds, color.grade = ifelse(diamonds$color == 'D' | diamonds$color == 'E' | diamonds$color == 'F', 'Colorless', 'Near Colorless' ))

data %>% 
  filter(price < 2000) %>% 
  group_by(color) %>% 
  mutate(size = x * y * z) %>% 
  filter(size < 200) %>% 
  ggplot(aes(x = carat, y = price)) +
  geom_point(alpha = 0.4, aes(color = color.grade)) +
  scale_x_log10(breaks = seq(0, 1, 0.2)) +
  scale_y_log10(breaks = seq(0, 2000, 500)) +
  labs(color = 'Color Grade', x = 'Carat', y = 'Price') +
  facet_grid(~ cut) +
  theme_bw() +
  ggsave('diamonds02.png', width = 15)

