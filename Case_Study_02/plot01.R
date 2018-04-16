gapminder %>%
  ggplot() +
  geom_point(mapping = aes(x = lifeExp, y = gdpPercap, size = pop / 100000, color = continent)) +
  scale_y_continuous(trans = "sqrt", name = "GDP per capita", limits = c(0, 50000)) +
  scale_x_continuous(name = "Life Expectancy") +
  labs(size = "Population (100k)", colour = "Continent") +
  facet_grid(~ year) +
  theme_bw() +
  ggsave(file = "plot01.png", width = 15)

