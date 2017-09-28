import formatError from './format-error'
import coffee from 'coffeescript'

sourceMap = (out) ->

  if out.v3SourceMap
  then JSON.parse out.v3SourceMap
  else null

export default (opts = {}) ->

  opts.bare       ?= true
  opts.sourceMap  ?= true

  name: 'coffee2'
  transform: (code, id) ->

    return {
      code
    } unless (extname id) is '.coffee'

    try
      out = coffee.compile code
      ,
        filename:  id
        bare:      opts.bare
        sourceMap: opts.sourceMap

    catch err

      if err.location?
        err.formattedMessage = formatError(
          code, id, err
        )

      throw err

    code: out.js
    map:  sourceMap out