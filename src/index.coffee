import * as preact from 'preact'
import {useState, useMemo} from 'preact/hooks'
import db, {onChange as dbOnChange} from './db.coffee'
import TextField from './TextField.coffee'
import Lecture from './Lecture.coffee'

App = ->
  [state, setState] = useState null
  dbOnChange setState
  useMemo -> db() # initial fetch of database
  unless state?
    return <h1>Loading...</h1>
  <>
    <h1>Staff Access to {state.title ? 'your class'}</h1>
    <TextField name="title" value={state.title} title="Course title"/>
    <h2>Lectures</h2>
    {for lecture in state.lectures ? []
      <Lecture {...lecture}/>
    }
    <h3>Add New Lecture:</h3>
    <Lecture/>
    <h3>Raw State:</h3>
    <pre>{JSON.stringify state}</pre>
  </>

preact.render <App/>, document.body
