rest = require 'restler'
moment = require 'moment'

eventFeed = 'https://api.github.com/orgs/nodekc/events'

GitEvent = (data) ->
  this.actor = data.actor.login
  this.actor_gravatar_id = data.actor.gravatar_id
  this.timeago = moment(new Date(data.created_at)).fromNow()
  this.commits = data.payload.commits
  this.repo = data.repo.name
  return

GitEvent.loadPushEvents = (limit, cb) ->
  rest.get(eventFeed).on('complete', (data) ->
    
    filtered = data.filter (x) ->
      x.type == "PushEvent"

    gitEvents = for x in filtered[0...limit]
      new GitEvent x

    cb gitEvents
  )
  
module.exports = GitEvent