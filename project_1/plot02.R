gapminder %>%
  filter(gdpPercap < 50000) %>%
  group_by(year, continent) %>%
  mutate(weight.pop = weighted.mean(gdpPercap, pop)) %>%
  ggplot(aes(y = gdpPercap, x = year, col = continent)) +
  geom_point(mapping = aes(size = pop / 25000, color = continent)) +
  geom_line(mapping = aes(group = country)) +
  geom_point(col = "black", aes(y = weight.pop, x = year, group = continent, size = pop / 25000)) +
  geom_line(col = "black", aes(y = weight.pop, x = year, group = continent)) +
  scale_y_continuous(name = "GDP per capita") +
  scale_x_continuous(name = "Year") +
  facet_grid(~ continent) +
  labs(size = "Population (100k)", colour = "Continent") +
  theme_bw() +
  ggsave(file = "plot02.png", width = 15)
