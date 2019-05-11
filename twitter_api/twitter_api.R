# twitter api data mining 
setwd('twitter')

# install.packages(c('twitteR','RCurl'))
# library('twitteR')
library(twitteR)
library(RCurl)
library(tm)
library(wordcloud)
### creat twitter app account
# https://apps.twitter.com/app
# link mobile to twitter account first
# authorization 
consumer_key=''
consumer_secret=''
access_token=''
access_secret=''
#install.packages('base64enc')
library(base64enc)
setup_twitter_oauth(consumer_key,consumer_secret, access_token,access_secret)

### precision medicine
### public and industry awearness of the topic 
pm=searchTwitter('precision+medicine',lang='en',n=10000,resultType='recent')# only returned 4000 if require 5000, problem with cleaning for 4000 itmes
pm_text=sapply(pm,function(x) x$getText())
pm_text <- sapply(pm_text,function(row) iconv(row, "latin1", "ASCII", sub=""))# remove emotions
a=Corpus(VectorSource(pm_text))
pm_key=tm_map(a,removePunctuation)
pm_key=tm_map(pm_key,content_transformer(tolower))
pm_key=tm_map(pm_key,removeWords,stopwords("english"))
pm_key=tm_map(pm_key,removeNumbers)
pm_key=tm_map(pm_key, stripWhitespace)
pm_key=tm_map(pm_key,removeWords,c('precision','medicine','precisionmedicine','can','help','next','america','american'))
pm_key= tm_map(pm_key, content_transformer(removeURL))
wordcloud(pm_key,min.freq=80)
dev.copy2pdf(file='precisionMedicine.pdf',width=5,height=5)
# co-accurance is mostly linked to NIH initiative, limited public and industry awearness




