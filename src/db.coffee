import arrayBufferConcat from 'arraybuffer-concat'

cgiScript = 'db.cgi'

setState = null

export onChange = (callback) ->
  setState = callback

export default db = (op = {}, fileData) ->
  body = JSON.stringify op
  if fileData?
    body = arrayBufferConcat(
      (new TextEncoder).encode "#{JSON.stringify op}\f"
    , fileData)
  response = await fetch cgiScript,
    method: 'POST'
    body: body
  data = await response.text()
  if response.ok
    setState JSON.parse data
  else
    console.error "Operation #{JSON.stringify op} failed on server: #{data}"
