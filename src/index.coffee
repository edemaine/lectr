import * as preact from 'preact'
import TextField from './TextField.coffee'

cgiScript = 'db.cgi'

class App extends preact.Component
  constructor: ->
    super()
    @db = @db.bind @
    @db()
  db: (op = {}) ->
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
        @setState data
      else
        console.error "Operation #{JSON.stringify op} failed on server: #{data}"
  render: (props, state) ->
    <>
      <h1>Welcome to {state.title ? 'untitled class'}!</h1>
      <TextField name="title" value={state.title ? ''} title="Course title" db={@db}/>
      <h3>Raw State:</h3>
      <pre>{JSON.stringify state}</pre>
    </>

preact.render <App/>, document.body
