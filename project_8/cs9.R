library(dplyr)
library(lubridate)
library(tidyquant)
library(dygraphs)
library(DT)
library(timetk)
library(ggrepel)

tickers_today <- c("CXW", "F", "GM", "JCP", "KR", "WDC", "NKE","T", "WDAY", "WFC", "WMT")
k <- getSymbols(tickers_today, src = "google", from = as.Date("2013-03-01"), to = as.Date("2018-03-09"))

tickers <- cbind(CXW$CXW.Close,
                 F$F.Close,
                 GM$GM.Close,
                 JCP$JCP.Close,
                 KR$KR.Close,
                 WDC$WDC.Close,
                 NKE$NKE.Close,
                 T$T.Close,
                 WDAY$WDAY.Close,
                 WFC$WFC.Close,
                 WMT$WMT.Close)
dygraph(tickers,
        main = "Stocks from select tickers over the past 5 years",
        ylab = "Close Price") %>%
  dyOptions(stepPlot = TRUE) %>%
  dyLimit(as.numeric(JCP[1,2]), color = "red") %>%
  dyLimit(as.numeric(F[1,2]), color = "red") %>%
  dyLimit(as.numeric(CXW[1,2]), color = "red") %>%
  dyLimit(as.numeric(GM[1,2]), color = "red") %>%
  dyLimit(as.numeric(KR[1,2]), color = "red") %>%
  dyLimit(as.numeric(WDC[1,2]), color = "red") %>%
  dyLimit(as.numeric(NKE[1,2]), color = "red") %>%
  dyLimit(as.numeric(T[1,2]), color = "red") %>%
  dyLimit(as.numeric(WDAY[1,2]), color = "red") %>%
  dyLimit(as.numeric(WFC[1,2]), color = "red") %>%
  dyLimit(as.numeric(WMT[1,2]), color = "red") %>%
  dySeries("JCP.Close", strokeWidth = 2, strokePattern = "dashed") %>%
  dySeries("F.Close", strokeWidth = 2, strokePattern = "dashed") %>%
  dySeries("CXW.Close", strokeWidth = 2, strokePattern = "dashed") %>%
  dyRangeSelector() %>%
  dyRoller(rollPeriod = 20) %>%
  dyUnzoom() %>%
  dyCrosshair(direction = "vertical") %>%
  dyHighlight(highlightCircleSize = 5,
              highlightSeriesBackgroundAlpha = 0.2,
              hideOnMouseOut = FALSE)

df <- data.frame(date=index(tickers), coredata(tickers)) %>%
  gather("ticker", "close", 2:12) %>% 
  mutate(ticker = gsub('.Close', '', ticker))

df <- df %>%
  group_by(ticker) %>%
  filter(date == "2018-03-09" | date == "2013-03-01") %>%
  summarize(profit = diff(close)) %>%
  ungroup() %>%
  mutate(status = case_when(profit >= 0 ~ 'good', profit < 0 ~ 'bad')) %>%
  right_join(df)

df %>% 
  ggplot(aes(x = date, y = close, col = ticker)) +
  geom_hline(yintercept = as.vector((df %>%
                                       group_by(ticker) %>%
                                       slice(1) %>%
                                       ungroup() %>%
                                       select(close))$close), 
             col = 'red', 
             linetype = 'dotted', 
             alpha = 0.5) +
  geom_line(data = df %>% filter(status == 'good')) + 
  geom_line(data = df %>% filter(status == 'bad'), linetype = 'dashed') + 
  geom_label_repel(data = df %>% filter(date == "2018-03-09"), show.legend = FALSE, aes(label = paste(ticker, profit, sep = ': ')), nudge_x = 30) +
  theme_minimal() +
  labs(y = 'Stock Close Price', 
       x = 'Date', 
       title = 'Stocks from select tickers over the past 5 years', 
       col = 'Ticker',
       subtitle = 'Dashed lines were unprofitable tickers, labels show total profit from March 2013-March 2018') +
  scale_x_date(expand = c(0, 150)) +
  ggsave('Case_Study_09/analysis/plot.png', width = 15)
  
  