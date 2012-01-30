date = require 'date-utils'
moment = require 'moment'
parser = require 'xml2json'
rest = require 'restler'
ical = require 'ical'

parseFeed = (feed) ->
  JSON.parse(parser.toJson(feed)).feed.entry
      
determineDate = (start, end) ->
  start = moment(start)
  end = moment(end)
  date = moment(new Date(start.native())).add('hours', -6).format('ddd, MMM D')

  return date if start.diff(end, 'days') == -1

  date + start.add('hours', -6).format(' h:mma CST')

eventFeed = 'http://www.google.com/calendar/ical/nodekc.org_e8lg6hesldeld1utui23ebpg7k%40group.calendar.google.com/public/basic.ics'

Event = (data) ->
  this.title = data.summary
  this.location = data.location 
  this.details = data.description
  this.when = determineDate(data.start, data.end)
  this.url = 'http://calendar.nodekc.org'

Event.load = (cb) ->
  ical.fromURL eventFeed, {}, (err, calendar) ->
      calendar or= {}
      events = for k,v of calendar
        new Event v
      cb events  

module.exports = Event