######## IMPORT LIBRARIES ########
library(ggplot2)
library(tidyverse)
library(dplyr)
library(readr)
library(stringr)
library(lubridate)
library(topicmodels)
library(tidytext)
library(tm)
library(rjson)
library(jsonlite)
library(rjsonio)
library(qdap)
library(quanteda)
library(scales)
library(ggpubr)
library(ggraph)
library(widyr)
library(cluster)
library(igraph)
library(glue)

######## IMPORT DATA ########
path_json <- "project/trump_tweets.json"
dat_ <- fromJSON(txt = path_json, flatten = TRUE) %>% 
  mutate(created_at = as.POSIXct(gsub("\\+0000 ", "", created_at), format = "%a %b %d %H:%M:%S %Y", tz = "UTC"), 
         created_at = with_tz(created_at, tzone = "America/Montreal")) %>% 
  na.omit()

######## WRANGLE ########
dat_plus <- dat_ %>% 
  mutate(year = year(created_at), 
         month = month(created_at), 
         week = week(created_at), 
         day = day(created_at), 
         hour = hour(created_at),
         wday = wday(created_at),
         month_year = floor_date(created_at, "month"),
         hashtags = str_extract_all(text, "#\\S+"),
         num_hashtags = mapply(function(i) length(hashtags[[i]]), 1:length(hashtags)),
         mentions = str_extract_all(text, "@\\S+"),
         num_mentions = mapply(function(i) length(mentions[[i]]), 1:length(mentions)),
  )

dat_plus$wday_name <- factor(dat_plus$wday, levels=1:7,
                      labels = c("Sunday", "Monday", "Tuesday", "Wednesday",
                                 "Thursday", "Friday", "Saturday"))


######## CORRELATIONS #########
corr_eqn <- function(x,y, digits = 2) {
  corr_coef <- round(cor(x, y), digits = digits)
  paste("italic(r) == ", corr_coef)
}

labels = data.frame(x = 7.5, y = 10, label = corr_eqn(dat_plus$num_mentions, dat_plus$num_hashtags))

plot1 <- dat_plus %>% 
  ggplot(aes(x = num_mentions, y = num_hashtags)) +
  geom_jitter() +
  geom_smooth(method = 'lm', se = F) +
  geom_label(data = labels, aes(x = x, y = y, label = label), parse = TRUE) +
  labs(x = "Number of mentions", 
       y = "Number of hashtags", 
       title = "Number of mentions vs number of hashtags",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/mentions_vs_hash.png", width = 12)

labels = data.frame(x = 5, y = 200, label = corr_eqn(dat_plus$num_hashtags, dat_plus$retweet_count))

plot2 <- dat_plus %>% 
  ggplot(aes(x = num_hashtags, y = retweet_count / 1000)) +
  geom_jitter() +
  geom_smooth(method = 'lm', se = F) +
  geom_label(data = labels, aes(x = x, y = y, label = label), parse = TRUE) +
  labs(x = "Number of hashtags", 
       y = "Retweet count 1k", 
       title = "Number of hashtags vs retweet count",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/hash_vs_retweet.png", width = 12)


labels = data.frame(x = 5, y = 200, label = corr_eqn(dat_plus$num_mentions, dat_plus$retweet_count))

plot3 <- dat_plus %>% 
  ggplot(aes(x = num_mentions, y = retweet_count / 1000)) +
  geom_jitter() +
  geom_smooth(method = 'lm', se = F) +
  geom_label(data = labels, aes(x = x, y = y, label = label), parse = TRUE) +
  labs(x = "Number of mentions",
       y = "Retweet count 1k", 
       title = "Number of mentions vs retweet count",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/mentions_vs_retweet.png", width = 12)

labels = data.frame(x = 6, y = 200, label = corr_eqn(dat$hour , dat$retweet_count))

plot4 <- dat_plus %>% 
  ggplot(aes(x = hour, y = retweet_count / 1000)) +
  geom_jitter() +
  geom_smooth(method = 'lm', se = F) +
  geom_label(data = labels, aes(x = x, y = y, label = label), parse = TRUE) +
  labs(x = "Time of day",
       y = "Retweet count 1k", 
       title = "Time of day vs retweet count",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/time_day_vs_retweet.png", width = 12)

ggarrange(plot1, plot2, plot3, plot4) +
  ggsave("project/combo_cor.png", width = 14)

dat_plus %>% 
  ggplot(aes(x = hour, y = retweet_count / 1000)) +
  geom_jitter() +
  geom_smooth() +
  labs(x = "Time of day",
       y = "Retweet count 1k", 
       title = "Retweets based on time of day",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/retweet_time_day.png", width = 12)

######## BAR CHARTS ########
plot1 <- dat_plus %>% 
  ggplot(aes(x = hour)) +
  geom_bar() +
  labs(x = "Time of day",
       y = "Count", 
       title = "Aggregate tweets by time of day",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/bar_tweet_time_day.png", width = 12)

plot2 <- dat_plus %>% 
  ggplot(aes(x = month, y = retweet_count / 1000)) +
  geom_jitter() +
  geom_smooth() +
  labs(x = "Month",
       y = "Retweet count 1k", 
       title = "Retweets based on month",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/retweet_month.png", width = 12)

plot3 <- dat_plus %>% 
  ggplot(aes(x = month)) +
  geom_bar() +
  labs(x = "Month",
       y = "Count", 
       title = "Aggregate tweets by month",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  scale_x_continuous(breaks = c(1,2,3,4,5,6,7,8,9,10,11,12)) +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/bar_tweet_month.png", width = 12)

plot4 <- dat_plus %>% 
  ggplot(aes(x = wday)) +
  geom_bar() +
  labs(x = "Day of week",
       y = "Count", 
       title = "Aggregate tweets by day of week",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  scale_x_continuous(breaks = c(1,2,3,4,5,6,7,8,9,10,11,12)) +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/bar_tweet_wday.png", width = 12)

ggarrange(plot1, plot3, plot4) +
  ggsave("project/combo_bar.png", width = 14)

######## PATTERNS ##########
test <- dat_plus %>% 
  filter(year >= 2017) %>% 
  mutate(test = wday_name) %>% 
  select(-wday_name) %>% 
  group_by(test, hour) %>% 
  summarise(count = max(n()))

plot1 <- dat_plus %>% 
  filter(year >= 2017) %>% 
  group_by(wday_name, hour) %>% 
  summarise(count = max(n())) %>% 
  ggplot(aes(x = hour, y = count, col = wday_name)) +
  geom_point(size = 2) +
  geom_line(size = 2) +
  facet_grid(wday_name ~ .) +
  geom_point(data = test, aes(x = hour, y = count, col = test), alpha = 0.3) +
  geom_line(data = test, aes(x = hour, y = count, col = test), alpha = 0.3) +
  guides(col = FALSE) +
  labs(x = "Hour",
       title = "2017+ - Presidency") +
  theme_minimal() +
  theme(axis.title.y = element_blank(),
        axis.title.x = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) 
  # ggsave("project/point_tweet_wday_hour_2017.png", width = 12)

test <- dat_plus %>% 
  filter(year < 2017) %>% 
  mutate(test = wday_name) %>% 
  select(-wday_name) %>% 
  group_by(test, hour) %>% 
  summarise(count = max(n()))

plot2 <- dat_plus %>% 
  filter(year < 2017) %>% 
  group_by(wday_name, hour) %>% 
  summarise(count = max(n())) %>% 
  ggplot(aes(x = hour, y = count, col = wday_name)) +
  geom_point(size = 2) +
  geom_line(size = 2) +
  facet_grid(wday_name ~ .) +
  geom_point(data = test, aes(x = hour, y = count, col = test), alpha = 0.3) +
  geom_line(data = test, aes(x = hour, y = count, col = test), alpha = 0.3) +
  guides(col = FALSE) +
  labs(x = "Hour",
       y = "Count",
       title = "< 2017") +
  theme_minimal() +
  theme(axis.title = element_text(family = "Trebuchet MS", 
                                    color = "#666666", 
                                    face = "bold", 
                                    size = 16))
  # ggsave("project/point_tweet_wday_hour_before.png", width = 12)

plot <- grid.arrange(plot2, plot1, 
             layout_matrix = rbind(c(1, 2),
                                   c(NA, NA)), 
             top = text_grob("Aggregate tweets by day of week and hour", color = "red", face = "bold", size = 20),
             bottom = text_grob("(based on data from trumptwitterarchive.com)", hjust = -1)) 
ggsave("project/point_tweet_wday_hour_combined.png", plot = plot, width = 14)


# Tweets by source
dat_plus %>% 
  group_by(source) %>% 
  summarise(count = max(n())) %>% 
  ggplot() +
  geom_bar(aes(x = reorder(source, -count), y = count), stat = "identity") +
  coord_flip() +
  labs(x = "Source",
       y = "Count", 
       title = "Aggregate tweets by source",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/bar_tweet_source.png", width = 12)

# Tweets by source & date
dat_plus %>% 
  group_by(source, month_year) %>% 
  summarise(count = max(n())) %>% 
  ggplot() +
  geom_point(aes(x = month_year, y = source, size = count)) +
  labs(x = "Date",
       y = "Source", 
       title = "Aggregate tweets by source and date",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/point_tweet_source_date.png", width = 12)

###################################### TEXT ANALYSIS #################################
# Get the text ready for analysis
tweets_text <- tolower(stripWhitespace(
  removeNumbers(
    removePunctuation(
      replace_contraction(
        replace_abbreviation(
          tolower(
            gsub("barackobamas", 
                 "barackobama", 
                 gsub("&amp;",
                      "", 
                      dat_plus$text)))))))))
tweets_text <- removeWords(tweets_text, gsub("again", "", stopwords("en")))
tweets_text <- removeWords(tweets_text, "realdonaldtrump")
tweets_text <- gsub("http([^ ]+)", "", tweets_text)
frequent_terms <- freq_terms(tweets_text, 30)

# Plot of most frequent words
frequent_terms %>%
  mutate(term = reorder(WORD, FREQ)) %>%
  ggplot(aes(term, FREQ)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  labs(x = "Frequency of appearance", 
       y = "Word", 
       title = "30 Most Frequently used words by @RealDonaldTrump",
       subtitle = "Removed realdonaldtrump from the list",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/freq_30.png", width = 12)

######## SENTIMENT         #####

tweets_text.df <- tibble(tweets_text)
d <- quanteda::dfm(tweets_text, verbose = FALSE)
tweets_td <- tidy(d)

# Get some sentiment analysis going
tweets_sentiments <- tweets_td %>% 
  inner_join(get_sentiments("bing"), by = c(term = "word")) %>% 
  filter(term != "trump")

# Get the most negative tweets
negative_tweets <- tweets_sentiments %>%
  count(document, sentiment, wt = count) %>%
  ungroup() %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = positive - negative) %>%
  arrange(sentiment) 

# Function to print tweets from id
print_tweets_from_id <- function(tweet_df, original_df, number_of_tweets = 5) {
  tweet_df <- tweet_df %>% 
    mutate(document = as.numeric(gsub("text", "", document)))
  count <- 1
  for(id in tweet_df$document) {
    if(count <= number_of_tweets)
      print(original_df$text[id])
    count <- count + 1
  }
}

# Print the most negative tweets
print_tweets_from_id(negative_tweets, dat_plus)

positive_tweets <- tweets_sentiments %>%
  count(document, sentiment, wt = count) %>%
  ungroup() %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(sentiment = negative - positive) %>%
  arrange(sentiment)

# Print the most positive tweets
print_tweets_from_id(positive_tweets, dat_plus)

# Plot sentiments
tweets_sentiments %>%
  count(sentiment, term, wt = count) %>%
  ungroup() %>%
  filter(n >= 150) %>%
  mutate(n = ifelse(sentiment == "negative", -n, n)) %>%
  mutate(term = reorder(term, n)) %>%
  ggplot(aes(term, n, fill = sentiment)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Word",
       y = "Contribution to sentiment",
       title = "Sentiment analysis of President Trump's tweets",
       caption = "(based on data from trumptwitterarchive.com)") +
  # theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/sentiments.png", width = 12)

######## FREQUENCY         ######
# Clean the text again, but keep the rest of the info
dat_plus <- dat_plus %>% 
  mutate(text = gsub("&amp;", "", text))
dat_plus$text <- dat_plus$text %>%
  replace_abbreviation() %>% 
  replace_contraction() %>% 
  removePunctuation() %>% 
  removeNumbers() %>% 
  stripWhitespace() %>% 
  tolower() %>% 
  removeWords("realdonaldtrump") %>% 
  gsub(pattern = "http([^ ]+)", replacement = "")

# Split by word
trump_words <- dat_plus %>% 
  unnest_tokens(word, text) %>%
  anti_join(stop_words %>% filter(word != "again"))

# Get frequencies over time
trump_freq <- trump_words %>%
  count(year, word) %>%
  ungroup() %>%
  complete(year, word, fill = list(n = 0)) %>%
  group_by(year) %>%
  mutate(year_total = sum(n),
         percent = n / year_total) %>%
  ungroup()

# Logistic regression
models <- trump_freq %>%
  group_by(word) %>%
  filter(sum(n) > 50) %>%
  do(tidy(glm(cbind(n, year_total - n) ~ year, .,
              family = "binomial"))) %>%
  ungroup() %>%
  filter(term == "year")

# Look at volcano chart, any way to spread it for more info??
plot1 <- models %>%
  arrange(desc(abs(estimate))) %>% 
  mutate(adjusted.p.value = p.adjust(p.value)) %>%
  ggplot(aes(estimate, adjusted.p.value)) +
  geom_point() +
  scale_y_log10() +
  # scale_y_sqrt() +
  geom_text(aes(label = word), vjust = 1, hjust = 1,
            check_overlap = TRUE) +
  labs(x = "Estimated change over time", 
       y = "Adjusted p-value",
       title = "Change of appearance of a word over time",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/volcano_change_appearance.png", width = 12)

# Look at top 6 words
plot2 <- models %>%
  top_n(6, abs(estimate)) %>%
  inner_join(trump_freq) %>%
  ggplot(aes(year, percent)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~ word) +
  scale_y_continuous(labels = percent_format()) +
  labs(x = "Year", 
       y = "Frequency of word in speech",
       title = "Top changes in word usage",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/freq_tweets.png", width = 12)

ggarrange(plot1, plot2) +
  ggsave("project/combo_freq.png", width = 14)

######## LDA               #################
# Turn df into dtm
myCorpus <- Corpus(VectorSource(tweets_text.df))  
dtm <- DocumentTermMatrix(myCorpus)

# Get the model
tweet_lda <- LDA(dtm, k = 4, control = list(seed = 121293))
tweet_topics <- tidy(tweet_lda, matrix = "beta")

tweet_top_terms <- tweet_topics %>%
  group_by(topic) %>%
  top_n(20, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

# Plot top terms
tweet_top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  labs(x = "Chance of occurence",
       y = "Word",
       title = "Top 20 words in occurence chance per topic",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/lda_occ_4_topic.png", width = 12)


######## Other exploration ######
trump_freq %>% 
  na.omit() %>% 
  group_by(year) %>% 
  arrange(n) %>% 
  top_n(5) %>% 
  ggplot() +
  geom_bar(aes(x = word, y = n, fill = year), stat = "identity")

test <- tibble(x = c(as.POSIXct("2017-01-01", tz = "UTC"), as.POSIXct("2015-06-01", tz = "UTC"), as.POSIXct("2011-04-01", tz = "UTC")),
               y = c(800, 1000, 600), lab = c("\nElected", "\nStart campaign", "\nObama takes on Trump"))

dat_plus %>% 
  group_by(month_year) %>% 
  summarise(n = n()) %>% 
  na.omit() %>% 
  ggplot(aes(x = month_year, y = n)) +
  geom_line(col = "grey") +
  geom_point() +
  geom_smooth() +
  geom_vline(xintercept = as.integer(test$x)) +
  geom_text(dat = test, aes(x = x, y = y, label = lab), col = "blue", angle = 90) +
  labs(x = "Date",
       y = "Number of tweets",
       title = "Number of tweets per month with important events",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/dates_num_tweets.png", width = 12)


######## CLUSTERING        ############# 
# Didn't really work...
dat_plus$words <- dat_plus$text %>%
  replace_abbreviation() %>% 
  replace_contraction() %>% 
  removePunctuation() %>% 
  removeNumbers() %>% 
  stripWhitespace() %>% 
  tolower() %>% 
  removeWords("realdonaldtrump") %>% 
  gsub(pattern = "http([^ ]+)", replacement = "")

tweet_clus <- dat_plus %>% 
  select(retweet_count, favorite_count, is_retweet, num_hashtags, num_mentions, day)
tweet_clus_scale <- tweet_clus %>% 
  scale()

clusters <- kmeans(tweet_clus_scale, 4)
clusplot(tweet_clus_scale, clusters$cluster, color = TRUE, shade = TRUE, label = 2, lines = 0)


######## TOKENIZING        ############
dat_plus <- dat_plus %>% 
  mutate(text = gsub("&amp;", "", text))
dat_plus$words <- dat_plus$text %>%
  tolower() %>% 
  gsub(pattern = "http([^ ]+)", replacement = "") %>% 
  removeWords(gsub("again", "", stopwords("en"))) %>% # Not sure if I should remove these
  replace_abbreviation() %>% 
  replace_contraction() %>% 
  removePunctuation() %>% 
  removeNumbers() %>% 
  stripWhitespace() %>% 
  tolower() %>% 
  removeWords("realdonaldtrump")
  
######## BIGRAMS
trump_bigrams <- dat_plus %>% 
  select(words, text, year) %>% 
  unnest_tokens(bigram, words, token = "ngrams", n = 2) 

trump_bigrams_counts <- trump_bigrams %>% 
  separate(bigram, c("word1", "word2"), sep = " ") %>%
  count(word1, word2, sort = TRUE)

bigram_tf_idf <- trump_bigrams %>%
  count(year, bigram) %>%
  bind_tf_idf(bigram, year, n) %>%
  arrange(desc(tf_idf))

bigram_tf_idf %>%
  group_by(year) %>% 
  top_n(10, wt = tf_idf) %>% 
  ungroup() %>% 
  mutate(term = reorder(bigram, tf_idf)) %>%
  ggplot(aes(term, tf_idf, fill = factor(year))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ year, scales = "free") +
  coord_flip() +
  labs(x = "Bigrams",
       y = "Importance (TFIDF)",
       title = "Top 10 bigrams per year found in Trump's tweets",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/bigram_bar.png", width = 12)

bigram_graph <- trump_bigrams_counts %>%
  na.omit() %>% 
  filter(n > 100) %>%
  graph_from_data_frame()

set.seed(24179)

a <- grid::arrow(type = "closed", length = unit(.15, "inches"))

ggraph(bigram_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07, 'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void() +
  ggsave("project/bigram_network.png", width = 12)
  

######## TRIGRAMS
trump_trigrams <- dat_plus %>%
  select(words, text, year) %>% 
  unnest_tokens(trigram, words, token = "ngrams", n = 3)

trump_trigrams_count <- trump_trigrams %>% 
  separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
  count(word1, word2, word3, sort = TRUE)

trigram_tf_idf <- trump_trigrams %>%
  count(year, trigram) %>%
  bind_tf_idf(trigram, year, n) %>%
  arrange(desc(tf_idf))

trigram_tf_idf %>%
  group_by(year) %>% 
  top_n(10, wt = tf_idf) %>% 
  ungroup() %>% 
  mutate(term = reorder(trigram, tf_idf)) %>%
  ggplot(aes(term, tf_idf, fill = factor(year))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ year, scales = "free") +
  coord_flip() +
  labs(x = "Trigrams",
       y = "Importance (TFIDF)",
       title = "Top 10 trigrams per year found in Trump's tweets",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/trigram_bar.png", width = 12)


trigram_graph <- trump_trigrams_count %>%
  na.omit() %>% 
  filter(n > 20) %>%
  graph_from_data_frame()

set.seed(24179)

a <- grid::arrow(type = "closed", length = unit(.15, "inches"))

ggraph(trigram_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07, 'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void() +
  ggsave("project/trigram_network.png", width = 12)

######## TETRAGRAMS
trump_tetragrams <- dat_plus %>%
  select(words, text, year) %>% 
  unnest_tokens(tetragram, words, token = "ngrams", n = 4)

trump_tetragrams_count <- trump_tetragrams %>% 
  separate(tetragram, c("word1", "word2", "word3", "word4"), sep = " ") %>%
  count(word1, word2, word3, word4, sort = TRUE)

tetragram_tf_idf <- trump_tetragrams %>%
  count(year, tetragram) %>%
  bind_tf_idf(tetragram, year, n) %>%
  arrange(desc(tf_idf))

tetragram_tf_idf %>%
  filter(year > 2012) %>% 
  group_by(year) %>% 
  top_n(10, wt = tf_idf) %>% 
  mutate(num = row_number()) %>% 
  filter(num <= 10) %>% 
  ungroup() %>% 
  mutate(term = reorder(tetragram, tf_idf)) %>%
  ggplot(aes(term, tf_idf, fill = factor(year))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ year, scales = "free") +
  coord_flip() +
  labs(x = "Tetragrams",
       y = "Importance (TFIDF)",
       title = "Top 10 tetragrams per year found in Trump's tweets",
       caption = "(based on data from trumptwitterarchive.com)") +
  theme_minimal() +
  theme(plot.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 22, 
                                  hjust = 0),
        axis.title = element_text(family = "Trebuchet MS", 
                                  color = "#666666", 
                                  face = "bold", 
                                  size = 16)) +
  ggsave("project/tetragram_bar.png", width = 12)


tetragram_graph <- trump_tetragrams_count %>%
  na.omit() %>% 
  filter(n > 10) %>%
  graph_from_data_frame()

set.seed(24179)

a <- grid::arrow(type = "closed", length = unit(.15, "inches"))

ggraph(tetragram_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07, 'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void() +
  ggsave("project/tetragram_network.png", width = 12)
