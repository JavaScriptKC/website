cache = require './cache'
Event = require './models/event'
Tweet = require './models/tweet'
Message = require './models/message'
GitEvent = require './models/gitevent'

tenMinutes = 10 * 60 * 1000

fetchMessages = cache.for tenMinutes, (cb) ->
  Message.load cb

fetchTweets = cache.for tenMinutes, (cb) ->
  Tweet.load cb

fetchEvents = cache.for tenMinutes, (cb) ->
  Event.load cb

fetchGitEvents = cache.for tenMinutes, (cb) ->
  GitEvent.load cb
    
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
      console.log events
      data.gitEvents = events
      cb()
}