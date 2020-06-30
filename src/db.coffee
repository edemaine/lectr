cgiScript = 'db.cgi'

setState = null

export onChange = (callback) ->
  setState = callback

export default db = (op = {}) ->
  ok = false
  fetch cgiScript,
    method: 'POST'
    body: JSON.stringify op
  .then (response) ->
    ok = response.ok
    response.text()
  .then (data) =>
    if ok
      data = JSON.parse data
      setState data
    else
      console.error "Operation #{JSON.stringify op} failed on server: #{data}"
