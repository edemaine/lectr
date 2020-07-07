cgiScript = 'db.cgi'

setState = null

export onChange = (callback) ->
  setState = callback

export default db = (op = {}) ->
  response = await fetch cgiScript,
    method: 'POST'
    body: JSON.stringify op
  data = await response.text()
  if response.ok
    setState JSON.parse data
  else
    console.error "Operation #{JSON.stringify op} failed on server: #{data}"
