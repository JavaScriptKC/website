parser = require 'xml2json'
rest = require 'restler'
date = require 'date-utils'
moment = require 'moment'
ical = require 'ical'

parseFeed = (feed) ->
  JSON.parse(parser.toJson(feed)).feed.entry

messageFeed = 'http://groups.google.com/group/kc-nodejs/feed/atom_v1_0_topics.xml'
eventFeed = 'http://www.google.com/calendar/ical/nodekc.org_e8lg6hesldeld1utui23ebpg7k%40group.calendar.google.com/public/basic.ics'
twitterFeed = 'http://search.twitter.com/search.json?q=%40nodekc'

lastMessageFetchResult = {}
lastEventFetchResult = {}
lastTwitterFetchResult = {}

determineDate = (start, end) ->
  start = moment(new Date start)
  end = moment(new Date end)
  date = start.format('dddd, MMM Do')

  return date if start.diff(end, 'days') == -1

  date + start.format(' h:mma') + " for " + start.from(end, true)

  
striphtml = (value) ->
  value.replace(/<(?:.|\n)*?>/gm, ' ')

timeAgo = (date) ->
  moment(new Date(date)).fromNow()

formatContent = (content) ->
  content = striphtml(content).trim()
  content += '\u2026' if /[\w]$/i.test content 
  content

fetchMessages = (cb) ->
  if lastMessageFetchResult.on? and lastMessageFetchResult.on > (new Date).addMinutes(-1)
    cb lastMessageFetchResult.value
    return
  
  rest.get(messageFeed).on('complete', (data) -> 
    
    messages = for x in parseFeed data 
      { subject: x.title.$t, body: formatContent(x.summary.$t), author:  x.author.name, timeago: timeAgo(x.updated), url: x.link.href } 
    
    lastMessageFetchResult.value = messages
    lastMessageFetchResult.on = new Date

    cb messages

    )

fetchTweets = (cb) ->
  if lastTwitterFetchResult.on? and lastTwitterFetchResult.on > (new Date).addMinutes(-1)
    cb lastTwitterFetchResult.value
    return

  rest.get(twitterFeed).on('complete', (data) -> 
    tweets = for x in data.results
      { timeago: timeAgo(x.created_at), created_at: x.created_at, created_by: x.from_user, tweet: x.text }
    
    lastTwitterFetchResult.value = tweets
    lastTwitterFetchResult.on = new Date
     
    cb tweets
  )

fetchEvents = (cb) ->
  if lastEventFetchResult.on? and lastEventFetchResult.on > (new Date).addMinutes(-1)
    cb lastEventFetchResult.value
    return
  
  ical.fromURL eventFeed, {}, (err, calendar) ->
      console.log calendar
      events = for k,v of calendar
        {title: v.summary, location: v.location, details: v.description, when: determineDate v.start, v.end }
      console.log events
      lastEventFetchResult.value = events
      lastEventFetchResult.on = new Date

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