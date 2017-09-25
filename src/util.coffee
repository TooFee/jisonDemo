module.exports =
  
  funcToStr: (func) ->
    func.toString()
    .split '\n'
    .reduce (r, c, i, a) ->
      return r if i is 0
      return r if i is a.length - 1
      _c = c.replace /^\s+/g, ''
      return r if (new RegExp /^var/).test _c
      [
        r...
        _c
      ]
    , []
    .join ''