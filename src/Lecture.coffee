import * as preact from 'preact'
import db from './db.coffee'
import usePropState from './usePropState.coffee'

export default Lectures = (props) ->
  <>
    {for lecture in props.lectures ? []
      <Lecture {...lecture} docTypes={props.docTypes} files={props.files}/>
    }
    {### Add New Lecture: ###}
    <Lecture/>
  </>

export Lecture = (props) ->
  [number, setNumber] = usePropState props, 'number'
  [title, setTitle] = usePropState props, 'title'
  [description, setDescription] = usePropState props, 'description'
  [video, setVideo] = usePropState props, 'video'
  newLecture = not props._id?
  onSubmit = (e) =>
    e.preventDefault()
    db 'lecture': {_id: props._id, number, title, description, video}
  submitName =
    if newLecture
      'Create'
    else
      'Save'
  disabled =
    (props.number == number and props.title == title and props.description == description and props.video == video)
  filesFor = (docType) ->
    files = (file for id, file of props.files \
      when file.lecture == props._id and file.docType == docType._id)
    files.sort (x, y) -> x.created - y.created
    files.reverse()
    files
  <form onSubmit={onSubmit} className="lecture" data-id={props._id}>
    {if newLecture
      <h3>Add New Lecture:</h3>
    }
    <label for={"lecture-#{props._id}-number"}>
      Number:
    </label>
    <input id={"lecture-#{props._id}-number"}
     type="text" value={number} placeholder="07 or L07 etc."
     onInput={(e) -> setNumber e.target.value}/>
    <br/>
    <label for={"lecture-#{props._id}-title"}>
      Title:
    </label>
    <input id={"lecture-#{props._id}-title"}
     type="text" value={title} placeholder="Introduction to Everything"
     onInput={(e) -> setTitle e.target.value}/>
    <br/>
    <label for={"lecture-#{props._id}-description"}>
      Description:
    </label>
    <input id={"lecture-#{props._id}-description"}
     type="text" value={description} placeholder="In this lecture, ..."
     onInput={(e) -> setDescription e.target.value}/>
    <br/>
    <label for={"lecture-#{props._id}-video"}>
      Video URL:
    </label>
    <input id={"lecture-#{props._id}-video"}
     type="text" value={video} placeholder="https://www.youtube.com/watch?v=VqeF98GGiXQ"
     onInput={(e) -> setVideo e.target.value}/>
    <br/>
    <input type="submit" value={submitName} disabled={disabled}/>
    {for docType in props.docTypes ? []
      <div className="docUpload">
        <label for={"lecture-#{props._id}-doc-#{docType.fileName}"}>
          {docType.displayName}
        </label>
        {if props.docs?[docType._id]
          <pre>{props.docs[docType._id]}</pre>
        }
        <input type="file" oninput={uploadDoc props._id, docType._id}/>
        {if (files = filesFor docType).length
          <ul>
            {for file in files
              <li><a href={"files/#{file._id}"} type={file.type}>{(new Date file.created).toISOString()} {file.name}</a></li>
            }
          </ul>
        }
      </div>
    }
  </form>

uploadDoc = (lecture, docType) -> (e) ->
  file = e.target?.files?[0]
  return unless file?
  buffer = await file.arrayBuffer()
  db
    file:
      lecture: lecture
      docType: docType
      name: file.name
      lastModified: file.lastModified
      size: file.size
      type: file.type
  , buffer
