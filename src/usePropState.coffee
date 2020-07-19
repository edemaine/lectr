import { useState, useMemo } from 'preact/hooks'

###
The `usePropState` hook defines a state variable similar to React's `useState`
(returning a `state` variable and `setState` function) but with the extra
feature that the state gets automatically set (initially) and reset (upon
change) to the corresponding `props` value.  In particular, when the server
gives us new database contents, `usePropState` will overwrite the state to
match the changes to `props`; but between such changes, the state can be
still changed via `setState` (e.g., an interacting user can type in changes).

Sample usage:

```coffee
[attrib, setAttrib] = usePropState props, 'attrib'
```
###

export default usePropState = (props, key) ->
  [state, setState] = useState null
  useMemo ->
    setState props[key]
  , [props[key]]
  [state, setState]
