rest = require 'restler'
moment = require 'moment'

eventFeed = 'https://api.github.com/orgs/nodekc/events'

GitEvent = (data) ->
  this.actor = data.actor.login
  this.actor_url = data.actor.url
  this.actor_gravatar_id = data.actor.gravatar_id
  this.timeago = moment(new Date(data.created_at)).fromNow()
  this.commits = data.payload.commits
  return

GitEvent.load = (cb) ->
  rest.get(eventFeed).on('complete', (data) ->
    
    filtered = data.filter (x) ->
      x.type == "PushEvent"

    gitEvents = for x in filtered
      new GitEvent x

    cb gitEvents
  )
  
module.exports = GitEvent