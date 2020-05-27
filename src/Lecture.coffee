import * as preact from 'preact'
import { useState } from 'preact/hooks'

export default Lecture = (props) ->
  [number, setNumber] = useState props.number
  [title, setTitle] = useState props.title
  [description, setDescription] = useState props.description
  [video, setVideo] = useState props.video
  newLecture = not props.number?
  onSubmit = (e) =>
    e.preventDefault()
    props.db 'newLecture': {number, title, description, video}
  submitName =
    if newLecture
      'Create'
    else
      'Save'
  disabled =
    not number or
    (props.number == number and props.title == title and props.descripion == description and props.video == video)
  <form onSubmit={onSubmit}>
    <label>
      Number: &nbsp;
      <input type="text" value={number} placeholder="07 or L07 etc."
       onInput={(e) -> setNumber e.target.value}/>
      <br/>
      Title: &nbsp;
      <input type="text" value={title} placeholder="Introduction to Everything"
       onInput={(e) -> setTitle e.target.value}/>
      <br/>
      Description: &nbsp;
      <input type="text" value={description} placeholder="In this lecture, ..."
       onInput={(e) -> setDescription e.target.value}/>
      <br/>
      Video URL: &nbsp;
      <input type="text" value={video} placeholder="https://www.youtube.com/watch?v=VqeF98GGiXQ"
       onInput={(e) -> setVideo e.target.value}/>
    </label>
    <br/>
    <input type="submit" value={submitName} disabled={disabled}/>
  </form>
