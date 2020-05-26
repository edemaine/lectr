import * as preact from 'preact'

cgiScript = 'db.cgi'

class App extends preact.Component
  constructor: ->
    super()
    @db()
  db: (op = {}) ->
    fetch cgiScript,
      method: 'POST'
      body: JSON.stringify op
    .then (response) ->
      if response.ok
        response.text()
      else
        throw new Error "Operation #{JSON.stringify op} failed on server"
    .then (data) =>
      data = JSON.parse data
      console.log 'new state', data
      @setState data
  render: (props, state) ->
    <>
      <h2>Hello!</h2>
      <h3>State: {JSON.stringify state}</h3>
    </>

preact.render <App/>, document.body
