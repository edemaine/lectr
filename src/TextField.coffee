import * as preact from 'preact'

export default class TextField extends preact.Component
  constructor: (props) ->
    super props
    @state = value: props.value
  render: (props, {value}) ->
    disabled =
      if value == props.value
        'disabled'
      else
        ''
    onInput = (e) =>
      @setState value: e.target.value
    onSubmit = (e) =>
      e.preventDefault()
      props.db "#{props.name}": @state.value
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
