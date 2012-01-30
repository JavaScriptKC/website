rest = require('restler')

eventFeed = 'https://api.github.com/orgs/nodekc/events'

GitEvent = (data) ->
    this.type = data.type
    this.actor = data.actor
    this.created_at = data.created_at
    this.commits = data.commits
    
GitEvent.load = (cb) ->
    rest.get(eventFeed).on('complete', (data) ->
        data or= []
        gitEvents = for x in data
            new GitEvent x
    )
    
module.exports = GitEvent