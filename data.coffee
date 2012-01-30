parser = require 'xml2json'
rest = require 'restler'
date = require 'date-utils'
moment = require 'moment'
ical = require 'ical'
cache = require './cache'
Event = require './models/event'
Tweet = require './models/tweet'
Message = require './models/message'

messageFeed = 'http://groups.google.com/group/kc-nodejs/feed/atom_v1_0_topics.xml'
eventFeed = 'http://www.google.com/calendar/ical/nodekc.org_e8lg6hesldeld1utui23ebpg7k%40group.calendar.google.com/public/basic.ics'
twitterFeed = 'http://search.twitter.com/search.json?q=%40nodekc&rpp=5'

parseFeed = (feed) ->
  JSON.parse(parser.toJson(feed)).feed.entry

tenMinutes = 10 * 60 * 1000

fetchMessages = cache.for tenMinutes, (cb) ->
  rest.get(messageFeed).on('complete', (data) -> 
    data or= ''

    messages = for x in parseFeed data 
      new Message x
    cb messages
    )

fetchTweets = cache.for tenMinutes, (cb) ->
  rest.get(twitterFeed).on('complete', (data) -> 
    data or= {}
    data.results or= []
    tweets = for x in data.results
      new Tweet x
        
    cb tweets
  )

fetchEvents = cache.for tenMinutes, (cb) ->
  ical.fromURL eventFeed, {}, (err, calendar) ->
      calendar or= {}
      events = for k,v of calendar
        new Event v
      cb events  

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
    fetchMessages (messages) ->
      data.messages = messages
      cb 'messages'
  tweets: (data, cb) ->
    fetchTweets (tweets) ->
      data.tweets = tweets
      cb 'tweets'
  events: (data, cb) ->
    fetchEvents (events) ->
      data.events = events
      cb 'events'
}