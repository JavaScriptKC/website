moment = require 'moment'
parser = require 'xml2json'
rest = require 'restler'
ical = require 'ical'
require 'datejs'

parseFeed = (feed) ->
  JSON.parse(parser.toJson(feed)).feed.entry

formatDate = (start, end) ->
  start = moment(start.setTimezone("CST"))
  end = moment(end.setTimezone("CST"))

  date = start.format('ddd, MMM D')

  if end.diff(start, 'days') == 1 and start.hours() == 0
    return date

  date + start.format(' h:mma CST')

eventFeed = 'http://www.google.com/calendar/ical/nodekc.org_e8lg6hesldeld1utui23ebpg7k%40group.calendar.google.com/public/basic.ics'

Event = (data) ->
  this.title = data.summary
  this.location = data.location 
  this.details = data.description
  this.when = formatDate(data.start, data.end)
  this.url = 'http://calendar.nodekc.org'
  return

Event.load = (cb) ->
  ical.fromURL eventFeed, {}, (err, calendar) ->
      calendar or= {}
      events = for k,v of calendar
        new Event v
      cb events  

module.exports = Event