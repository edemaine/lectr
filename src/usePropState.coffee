import { useState, useMemo } from 'preact/hooks'

export default usePropState = (props, key) ->
  [state, setState] = useState null
  useMemo ->
    setState props[key]
  , [props[key]]
  [state, setState]
