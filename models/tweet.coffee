moment = require 'moment'
rest = require 'restler'
twitterFeed = 'http://search.twitter.com/search.json?q=%40nodekc&rpp=5'

Tweet = (data) ->
  this.created_by = data.from_user
  this.tweet = data.text
  this.timeago = moment(new Date(data.created_at)).fromNow()
  this.created_at = data.created_at

Tweet.load = (cb) ->
  rest.get(twitterFeed).on('complete', (data) -> 
    data or= {}
    data.results or= []
    
    tweets = for x in data.results
      new Tweet x
        
    cb tweets
  )

module.exports = Tweet
