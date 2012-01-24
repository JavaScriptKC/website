parser = require './utility/atomParser.js'
rest = require 'restler'

fetchMessages = (cb) ->
  rest.get('http://groups.google.com/group/kc-nodejs/feed/atom_v1_0_topics.xml').on('complete', (data) -> cb(parser(data).items))

fetchTweets = (cb) ->
  rest.get('http://search.twitter.com/search.json?q=%40nodekc').on('complete', (data) -> cb(data))

fetchEvents = (cb) ->
  rest.get('http://www.google.com/calendar/feeds/nodekc.org_e8lg6hesldeld1utui23ebpg7k%40group.calendar.google.com/public/basic').on('complete', (data) -> cb(parser(data).items))

module.exports = {
  load: (keys...) ->
    return (req, res, next) => 
      finished = []
      res.data or= {}
      keys.forEach (key) =>
        this[key] res.data, (k) ->
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
  events: (data, cb) ->
    fetchEvents (result) ->
      data.events = result
      cb 'events'
}