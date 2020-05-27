import * as preact from 'preact'
import { useState } from 'preact/hooks'

export default TextField = (props) ->
  [value, setValue] = useState props.value
  disabled =
    if value == props.value
      'disabled'
    else
      ''
  onInput = (e) =>
    setValue e.target.value
  onSubmit = (e) =>
    e.preventDefault()
    props.db "#{props.name}": value
  <form onSubmit={onSubmit}>
    <label>
      {props.title}: &nbsp;
      <input type="text" value={value} onInput={onInput}/>
    </label>
    {if value == props.value
       <input type="submit" value="Save" disabled/>
     else
       <input type="submit" value="Save"/>}
  </form>
