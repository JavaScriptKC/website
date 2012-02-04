moment = require 'moment'
rest = require 'restler'
<<<<<<< HEAD

twitter_feed_url = 'http://search.twitter.com/search.json?q=%40nodekc&rpp=5'
=======
twitter = require '../lib/twitter-text'
twitterFeed = 'http://search.twitter.com/search.json?q=%40nodekc&rpp=5&include_entities=1'
>>>>>>> c4e07a54c5e47bc802e1336efcae6b4e7e321eba

Tweet = (data) ->
  console.log data
  this.created_by = data.from_user
  this.tweet = twitter.autoLink data.text, urlEntities: data.entities.urls
  this.timeago = moment(new Date(data.created_at)).fromNow()
  this.created_at = data.created_at
  return

Tweet.load = (cb) ->
  rest.get(twitter_feed_url)
    .on 'complete', (data) -> 
      data or= {}
      data.results or= []
      
      tweets = for x in data.results
        new Tweet x
          
      cb tweets

module.exports = Tweet