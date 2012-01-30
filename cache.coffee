module.exports = {
  for: (expiration, work) ->
    lastResult = null
    lastModified = null
    return (complete) -> 
       if lastModified? and (new Date).getTime() - expiration < lastModified
         complete lastResult
       else
         work (data) ->         
           lastResult = data
           lastModified = (new Date).getTime()
           complete lastResult
}