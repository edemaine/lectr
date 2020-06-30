import * as preact from 'preact'
import db from './db.coffee'
import usePropState from './usePropState.coffee'

export default Lectures = (props) ->
  <>
    {for lecture in props.lectures ? []
      <Lecture {...lecture}/>
    }
    <h3>Add New Lecture:</h3>
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
  <form onSubmit={onSubmit}>
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
  </form>
