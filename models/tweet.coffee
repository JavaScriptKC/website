moment = require 'moment'
rest = require 'restler'
twitter = require '../lib/twitter-text'
twitterFeed = 'http://search.twitter.com/search.json?q=%40nodekc&rpp=5&include_entities=1'

Tweet = (data) ->
  console.log data
  this.created_by = data.from_user
  this.tweet = twitter.autoLink data.text, urlEntities: data.entities.urls
  this.timeago = moment(new Date(data.created_at)).fromNow()
  this.created_at = data.created_at
  return

Tweet.load = (cb) ->
  rest.get(twitterFeed).on('complete', (data) -> 
    data or= {}
    data.results or= []
    
    tweets = for x in data.results
      new Tweet x
        
    cb tweets
  )

module.exports = Tweet