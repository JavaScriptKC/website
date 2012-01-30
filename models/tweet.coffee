moment = require 'moment'

Tweet = (data) ->
  this.created_by = data.from_user
  this.tweet = data.text
  this.timeago = moment(new Date(data.created_at)).fromNow()
  this.created_at = data.created_at

module.exports = Tweet
