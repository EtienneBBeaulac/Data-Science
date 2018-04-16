# library(dplyr)
# library(lubridate)
# library(tidyquant)
# library(dygraphs)
# library(DT)

# k <- getSymbols("KR", src = "yahoo", from = as.Date("2013-03-01"), to = as.Date("2018-03-07"))

datatable(KR)

KR.no_vol <- KR[, colnames(KR) != 'KR.Volume']
KR.vol <- KR$KR.Volume
dygraph(KR.no_vol) %>%
  dyCandlestick() %>% 
  dyRangeSelector() %>%
  dyLegend(show = "follow")

dygraph(KR.vol) %>%
  dyRangeSelector() %>%
  dyLegend(show = "follow")