import { funcToStr } from '../util'

export default grammar =
  lex:
    rules: [
      [
        "\\s+"
        -> # /* skip whitespace */"
      ]
      [
        "[0-9]+(?:\\.[0-9]+)?\\b"
        -> return 'NUMBER'
      ]

      [ "\\*", -> return '*' ]
      [ "\\/", -> return '/' ]
      [ "-", -> return '-' ]
      [ "\\+", -> return '+' ]

      [ "\\^", -> return '^' ]
      [ "!", -> return '!' ]
      [ "%", -> return '%' ]

      [ "\\(", -> return '(' ]
      [ "\\)", -> return ')' ]

      [ "PI\\b", -> return 'PI' ]
      [ "E\\b", -> return 'E' ]

      [ "$", -> return 'EOF' ]
    ]

  bnf:
    expressions: [
      [ "e EOF", -> return $1 ]
    ]

    e: [
      [ "e + e", funcToStr -> $$ = $1 + $3 ]
      [ "e - e", funcToStr -> $$ = $1 - $3 ]
      [ "e * e", funcToStr -> $$ = $1 * $3 ]
      [ "e / e", funcToStr -> $$ = $1 / $3 ]

      [
        "e ^ e"
        funcToStr ->
          $$ = Math.pow $1, $3
      ]
      [
        "e !"
        funcToStr ->
          $$ = (
            (n) ->
              return 1 if n is 0
              return arguments.callee( n - 1 ) * n
          )($1) 
      ]
      [ "e %", funcToStr -> $$ = $1 / 100 ]

      [
        "- e"
        funcToStr -> $$ = -$2
        prec: "UMINUS"
      ]
      [ "( e )", funcToStr -> $$ = $2 ]

      [ "NUMBER", funcToStr -> $$ = Number(yytext) ]

      [ "E", funcToStr -> $$ = Math.E ]
      [ "PI", funcToStr -> $$ = Math.PI ]
    ]

  operators: [
    [
      "left"
      "+", "-", "*", "/"
      "^", "!", "%"
      "E", "PI"
      "UMINUS"
    ]
  ]