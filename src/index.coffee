import * as preact from 'preact'
import {useState, useMemo} from 'preact/hooks'
import db, {onChange as dbOnChange} from './db.coffee'
import TextField from './TextField.coffee'
import DocumentTypes from './DocumentType.coffee'
import Lectures from './Lecture.coffee'

App = ->
  [state, setState] = useState null
  dbOnChange setState
  useMemo -> db() # initial fetch of database
  unless state?
    return <h1>Loading...</h1>
  <>
    <h1>Staff Access to {state.title ? 'your class'}</h1>
    <TextField name="title" value={state.title} title="Course title"/>
    <DocumentTypes docTypes={state.docTypes}/>
    <h2>Lectures</h2>
    <Lectures lectures={state.lectures} docTypes={state.docTypes}/>
    <details style="margin-top:2ex">
      <summary>Raw State</summary>
      <pre>{JSON.stringify state, null, 2}</pre>
    </details>
  </>

preact.render <App/>, document.body
