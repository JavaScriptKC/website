moment = require 'moment'
rest = require 'restler'
FeedParser = require 'feedparser'

message_feed_url = 'http://groups.google.com/group/nodekc/feed/atom_v1_0_topics.xml'

striphtml = (value) ->
  value.replace(/<(?:.|\n)*?>/gm, ' ')

formatContent = (content) ->
  content = striphtml(content).trim()
  content += '\u2026' if /[\w]$/i.test content 
  content

Message = (data) ->
  this.subject = data.title
  this.body = formatContent data.description
  this.timeago = moment(new Date(data.date)).fromNow()
  this.url = data.link
  this.author = data.author
  return

Message.load = (cb) ->
  rest.get(message_feed_url)
    .on 'complete', (data) -> 
      parser = new FeedParser()

      articles = []

      parser.on 'article', (article) ->
        articles.push(article)

      parser.parseString data 

      messages = for x in articles
        new Message x
        
      cb messages

module.exports = Message