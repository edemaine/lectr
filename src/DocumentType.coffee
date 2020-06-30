import * as preact from 'preact'
import db from './db.coffee'
import usePropState from './usePropState.coffee'

export default DocumentTypes = (props) ->
  <>
    <h2>Documents Types (slides, handwritten/scribe notes, etc.)</h2>
    {for docType in props.docTypes ? []
      <DocumentType {...docType}/>
    }
    <h3>Add New Document Type:</h3>
    <DocumentType/>
  </>

export DocumentType = (props) ->
  [fileName, setFileName] = usePropState props, 'fileName'
  [displayName, setDisplayName] = usePropState props, 'displayName'
  #[description, setDescription] = usePropState props, 'description'
  newDocType = not props._id?
  onSubmit = (e) =>
    e.preventDefault()
    db 'docType': {_id: props._id, fileName, displayName}
  submitName =
    if newDocType
      'Create'
    else
      'Save'
  disabled =
    (props.fileName == fileName and props.displayName == displayName)
  <form onSubmit={onSubmit}>
    <label for={"docType-#{props._id}-displayName"}>
      Display Name:
    </label>
    <input id={"docType-#{props._id}-displayName"}
     type="text" value={displayName}
     placeholder="Slides / Handwritten notes / Scribe notes"
     onInput={(e) -> setDisplayName e.target.value}/>
    <br/>
    <label for={"docType-#{props._id}-fileName"}>
      Filename:
    </label>
    <input id={"docType-#{props._id}-fileName"}
     type="text" value={fileName}
     placeholder="slides / notes / scribe"
     onInput={(e) -> setFileName e.target.value}/>
    <br/>
    <input type="submit" value={submitName} disabled={disabled}/>
  </form>
