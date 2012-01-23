parser = require './utility/atomParser.js'
rest = require 'restler'

fetchMessages = (cb) ->
  rest.get('http://groups.google.com/group/kc-nodejs/feed/atom_v1_0_topics.xml').on('complete', (data) -> cb(parser(data).items))

fetchTweets = (cb) ->
  rest.get('http://search.twitter.com/search.json?q=%40nodekc').on('complete', (data) -> cb(data))

module.exports = {
  load: (keys...) ->
    that = this
    return (req, res, next) -> 
      finished = []
      res.data or= {}
      keys.forEach (key) ->
        that[key] res.data, (k) ->
          finished.push k
          next() if finished.length == keys.length
          
  messages: (data, cb) ->
    fetchMessages (items) ->
      data.messages = items
      cb 'messages'
  tweets: (data, cb) ->
    fetchTweets (result) ->
      data.tweets = result
      cb 'tweets'
}