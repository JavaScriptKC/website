date = require 'date-utils'
moment = require 'moment'

Event = (data) ->
  this.title = data.summary
  this.location = data.location 
  this.details = data.description
  this.when = determineDate(data.start, data.end)
  this.url = createEventUrl data.uid

determineDate = (start, end) ->
  start = moment(start)
  end = moment(end)
  date = moment(new Date(start.native())).add('hours', -6).format('ddd, MMM D')

  return date if start.diff(end, 'days') == -1

  date + start.add('hours', -6).format(' h:mma CST')

createEventUrl = (id) ->
  id = id.split('@')[0]
  id = new Buffer(id + ' e8lg6hesldeld1utui23ebpg7k@google.com').toString('base64').replace('==', '')

module.exports = Event