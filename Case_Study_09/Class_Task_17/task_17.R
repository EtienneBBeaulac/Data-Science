# library(ggplot2)
# library(tidyverse)
# library(dplyr)
# library(lubridate)
# library(tidyquant)
# 
# # Walmart, Google, Microsoft
# my_stocks <- c("WMT", "GOOG", "MSFT") %>%
#   tq_get(get  = "stock.prices",
#          from = "2017-10-01") %>%
#   group_by(symbol) %>%
#   tq_transmute(select     = close,
#                mutate_fun = periodReturn,
#                period     = "daily",
#                col_rename = "log")
# 
# my_portfolio <- my_stocks %>%
#   tq_portfolio(assets_col   = symbol,
#                returns_col  = log,
#                weights      = c(1/3, 1/3, 1/3),
#                col_rename   = "invest_growth",
#                wealth.index = TRUE) %>%
#   mutate(invest_growth = invest_growth * 1000)
# 
# # Apple, Amazon, Bitcoin
# friend_stocks <- c("AAPL", "AMZN", "BTSC") %>%
#   tq_get(get  = "stock.prices",
#          from = "2017-10-01") %>%
#   group_by(symbol) %>%
#   tq_transmute(select     = close,
#                mutate_fun = periodReturn,
#                period     = "daily",
#                col_rename = "log")
# 
# friend_portfolio <- friend_stocks %>%
#   tq_portfolio(assets_col   = symbol,
#                returns_col  = log,
#                weights      = c(1/3, 1/3, 1/3),
#                col_rename   = "invest_growth",
#                wealth.index = TRUE) %>%
#   mutate(invest_growth = invest_growth * 1000)
# 
# plot1 <- my_portfolio %>%
#   ggplot() +
#   geom_point(aes(x = date, y = invest_growth), col = 'blue') +
#   geom_line(aes(x = date, y = invest_growth), col = 'blue') +
#   geom_point(data = friend_portfolio, aes(x = date, y = invest_growth), col = 'green') +
#   geom_line(data = friend_portfolio, aes(x = date, y = invest_growth), col = 'green') +
#   theme_minimal() +
#   labs(title = 'Comparison of Portfolios',
#        subtitle = "Blue is 33% Walmart, 33% Google, 33% Microsoft\nGreen is 33% Apple, 33% Amazon, 33% Bitcoin",
#        x = 'Date',
#        y = 'Portfolio growth')
# 
plot2 <- friend_stocks %>%
  ggplot(aes(x = date, y = log, col = symbol)) +
  geom_point() +
  geom_smooth() +
  theme_minimal() +
  labs(title = "Change in stock prices",
       subtitle = "It is obvious that Bitcoin accounts for most of the change",
       x = 'Date',
       y = 'Log of change')
# 
# friend_apple_portfolio <- friend_stocks %>%
#   tq_portfolio(assets_col   = symbol,
#                returns_col  = log,
#                weights      = c(1, 0, 0),
#                col_rename   = "invest_growth",
#                wealth.index = TRUE) %>%
#   mutate(invest_growth = invest_growth * 1000 / 3)
# 
# friend_amazon_portfolio <- friend_stocks %>%
#   tq_portfolio(assets_col   = symbol,
#                returns_col  = log,
#                weights      = c(0, 1, 0),
#                col_rename   = "invest_growth",
#                wealth.index = TRUE) %>%
#   mutate(invest_growth = invest_growth * 1000 / 3)
# 
# friend_bitcoin_portfolio <- friend_stocks %>%
#   tq_portfolio(assets_col   = symbol,
#                returns_col  = log,
#                weights      = c(0, 0, 1),
#                col_rename   = "invest_growth",
#                wealth.index = TRUE) %>%
#   mutate(invest_growth = invest_growth * 1000 / 3)

no_bit_plot <- friend_apple_portfolio %>% 
  ggplot(aes(x = date, y = invest_growth)) +
  geom_point() +
  geom_line() +
  geom_point(data = friend_amazon_portfolio, col = '#ff9900') + 
  geom_line(data = friend_amazon_portfolio, col = '#ff9900') +
  labs(title = "Individual Stocks of Friend's Portfolio - No Bitcoin",
       subtitle = "AMZN (orange) - APPL (black)\nWithout Bitcoin, these two stocks are doing rather well",
       x = "Date",
       y = "Portfolio growth") +
  theme_minimal()

w_bit_plot <- friend_apple_portfolio %>% 
  ggplot(aes(x = date, y = invest_growth)) +
  geom_point() +
  geom_line() +
  geom_point(data = friend_amazon_portfolio, col = '#ff9900') + 
  geom_line(data = friend_amazon_portfolio, col = '#ff9900') +
  geom_point(data = friend_bitcoin_portfolio, col = 'red') +
  geom_line(data = friend_bitcoin_portfolio, col = 'red') +
  labs(title = "Individual Stocks of Friend's Portfolio - With Bitcoin",
       subtitle = "AMZN (orange) - APPL (black) - BTSC (red)\nWith Bitcoin, Apple and Amazon pale in comparison, until the drop",
       x = "Date",
       y = "Portfolio growth") +
  theme_minimal()

ggsave("Case_Study_09/Class_Task_17/plot1.png", plot = plot1)
ggsave("Case_Study_09/Class_Task_17/plot2.png", plot = plot2)
ggsave("Case_Study_09/Class_Task_17/no_bit.png", plot = no_bit_plot)
ggsave("Case_Study_09/Class_Task_17/w_bit.png", plot = w_bit_plot)
