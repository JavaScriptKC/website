moment = require 'moment'

Message = (data) ->
  this.subject = data.title.$t
  this.body = formatContent data.summary.$t
  this.author = data.author.name
  this.timeago = moment(new Date(data.updated)).fromNow()
  this.url = data.link.href

striphtml = (value) ->
  value.replace(/<(?:.|\n)*?>/gm, ' ')

formatContent = (content) ->
  content = striphtml(content).trim()
  content += '\u2026' if /[\w]$/i.test content 
  content

module.exports = Message
