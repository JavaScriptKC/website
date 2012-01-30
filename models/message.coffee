moment = require 'moment'
parser = require 'xml2json'
rest = require 'restler'

messageFeed = 'http://groups.google.com/group/kc-nodejs/feed/atom_v1_0_topics.xml'

parseFeed = (feed) ->
  JSON.parse(parser.toJson(feed)).feed.entry

striphtml = (value) ->
  value.replace(/<(?:.|\n)*?>/gm, ' ')

formatContent = (content) ->
  content = striphtml(content).trim()
  content += '\u2026' if /[\w]$/i.test content 
  content

Message = (data) ->
  this.subject = data.title.$t
  this.body = formatContent data.summary.$t
  this.author = data.author.name
  this.timeago = moment(new Date(data.updated)).fromNow()
  this.url = data.link.href
  this.author = data.author.name

Message.load = (cb) ->
  rest.get(messageFeed).on('complete', (data) -> 
    data or= ''

    messages = for x in parseFeed data 
      new Message x
      
    cb messages
  )

module.exports = Message