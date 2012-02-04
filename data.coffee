cache = require './cache'
Event = require './models/event'
Tweet = require './models/tweet'
Message = require './models/message'
GitEvent = require './models/gitevent'

ten_minutes = 10 * 60 * 1000

fetchMessages = cache.for ten_minutes, (cb) ->
  Message.load cb

fetchTweets = cache.for ten_minutes, (cb) ->
  Tweet.load cb

fetchEvents = cache.for ten_minutes, (cb) ->
  Event.load cb

fetchGitEvents = cache.for ten_minutes, (cb) ->
  GitEvent.loadPushEvents 10, cb
    
module.exports = {
  load: (keys...) ->
    return (req, res, next) => 
      jobs = keys.length
      res.data or= {}
      keys.forEach (key) =>
        this[key] res.data, () ->
          next() if --jobs == 0 
  messages: (data, cb) ->
    fetchMessages (messages) ->
      data.messages = messages
      cb()
  tweets: (data, cb) ->
    fetchTweets (tweets) ->
      data.tweets = tweets
      cb()
  events: (data, cb) ->
    fetchEvents (events) ->
      data.events = events
      cb()
  gitEvents: (data, cb) ->
    fetchGitEvents (events) ->
      data.gitEvents = events
      cb()
}