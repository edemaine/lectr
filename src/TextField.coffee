import * as preact from 'preact'
import db from './db.coffee'
import usePropState from './usePropState.coffee'

export default TextField = (props) ->
  [value, setValue] = usePropState props, 'value'
  onInput = (e) =>
    setValue e.target.value
  onSubmit = (e) =>
    e.preventDefault()
    db "#{props.name}": value
  <form onSubmit={onSubmit}>
    <label for={props.name}>
      {props.title}:
    </label>
    <input id={props.name} type="text" value={value} onInput={onInput}/>
    <input type="submit" value="Save" disabled={value == props.value}/>
  </form>
