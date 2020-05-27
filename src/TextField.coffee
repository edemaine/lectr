import * as preact from 'preact'
import { useState } from 'preact/hooks'

export default TextField = (props) ->
  [value, setValue] = useState props.value
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
    <input type="submit" value="Save" disabled={value == props.value}/>
  </form>
