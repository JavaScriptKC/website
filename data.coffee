parser = require './utility/atomParser.js'
rest = require 'restler'

fetchMessages = (cb) ->
  rest.get('http://groups.google.com/group/kc-nodejs/feed/atom_v1_0_topics.xml').on('complete', (data) -> cb(parser(data).items))

module.exports = {
  loadMessages: (req, res, next) ->
    fetchMessages (items) ->
      res.data = { 
        messages: items
      }

      next()
}