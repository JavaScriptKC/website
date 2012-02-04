module.exports = {
  for: (expiration, work) ->
    last_result = null
    last_modified = null
    return (complete) -> 
       if last_modified? and (new Date).getTime() - expiration < last_modified
         complete last_result
       else
         work (data) ->         
           last_result = data
           last_modified = (new Date).getTime()
           complete last_result
}