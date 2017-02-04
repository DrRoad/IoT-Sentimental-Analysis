#load the library
library("twitteR")
library("NLP")
library("tm")
library("wordcloud")
library("RColorBrewer")
library("SnowballC")
library("syuzhet")


#Twitter API credentials
api_key <- "Your API key"
api_secret <- "Your API secret"
token_key <- "Your Token Key"
token_secret <- "Your Token secret"

#Connect to Twitter
setup_twitter_oauth(api_key,api_secret,token_key,token_secret)

#download tweets
tweets <- searchTwitter("IOT OR IoT OR internetofthings OR INTERNETOFTHINGS OR InternetOfThings OR iot", n=1000, lang = "en")

#convert to dataframes
tweets.df <- twListToDF(tweets)

#Create and clean Corpus. Remove stop words
cor <- Corpus(VectorSource(tweets.df$text))

cor <- tm_map(cor, PlainTextDocument)

cor <- tm_map(cor,removePunctuation)

cor <- tm_map(cor,stemDocument)

cor <- tm_map(cor,removeWords,stopwords(kind = "english"))

cor <- tm_map(cor,removeWords,c('Iot','IoT','IOT','#iot','#IoT','#things','#internet','internet','things'))

#Check Corpus
inspect(cor)

#Create a word cloud
wordcloud(cor,scale=c(2,0.2),  max.words = 100, random.order = FALSE,colors = brewer.pal(8,"Set2"))

#Extract Sentiments
sentiments <- get_nrc_sentiment((iconv(tweets.df$text, 'UTF-8', 'ASCII')))

#Calculate Magnitude of each Sentiments
senti_sums <-(colSums(sentiments))

#Plot scores for each Sentiments observed
barplot(senti_sums, width = 0.3,col =  RColorBrewer::brewer.pal(4,'Pastel2'),
        main = "Sentiments of Tweeple",xlab= "Sentiments" ,ylab = "Scores",
        ylim = c(0,max(senti_sums)))

