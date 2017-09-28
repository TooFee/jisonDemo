import {
  createFilter
  makeLegalIdentifier
} from 'rollup-pluginutils'

export default json = (options = {}) ->

  filter = createFilter options.include, options.exclude

  name: 'json'

  transform: (json, id) ->
    return null if ( id.slice - 5 ) isnt '.json'
    return null if not filter id

    data = JSON.parse json
    code = ''

    ast =
      type: 'Program'
      sourceType: 'module'
      start: 0
      end: null
      body: []

    if (Object.prototype.toString.call data) isnt '[object Object]'

      code = "export default #{json};"

      ast.body.push
        type: 'ExportDefaultDeclaration'
        start: 0
        end: code.length
        declaration:
          type: 'Literal'
          start: 15
          end: code.length - 1
          value: null
          raw: 'null'

    else

      indent =
        if 'indent' in options
        then options.indent
        else '\t'

      validKeys = []
      invalidKeys = []

      Object.keys data
      .forEach (key) =>
        if key is makeLegalIdentifier key
        then validKeys.push key
        else invalidKeys.push key

      char = 0

      validKeys.forEach (key) =>
        declarationType = if options.preferConst then 'const' else 'var'
        declaration = "export #{declarationType} #{key} = #{JSON.stringify data[key]};"

        start = char
        end = start + declaration.length

        # generate fake AST node while we're here
        ast.body.push
          type: 'ExportNamedDeclaration'
          start: char
          end: char + declaration.length
          declaration:
            type: 'VariableDeclaration'
            start: start + 7 # 'export '.length
            end: end
            declarations: [
                type: 'VariableDeclarator'
                start: start + 7 + declarationType.length + 1 # `export ${declarationType} `.length
                end: end - 1
                id:
                  type: 'Identifier'
                  start: start + 7 + declarationType.length + 1 # `export ${declarationType} `.length
                  end: start + 7 + declarationType.length + 1 + key.length # `export ${declarationType} ${key}`.length
                  name: key
                init:
                  type: 'Literal'
                  start: start + 7 +
                    declarationType.length + 1 +
                    key.length + 3 # `export ${declarationType} ${key} = `.length
                  end: end - 1
                  value: null
                  raw: 'null'
            ]
            kind: declarationType
          specifiers: []
          source: null

        char = end + 1
        code += "#{declaration}\n"

      defaultExportNode =
        type: 'ExportDefaultDeclaration'
        start: char
        end: null
        declaration:
          type: 'ObjectExpression'
          start: char + 15
          end: null
          properties: []

      char += 17 + indent.length # 'export default {\n\t'.length'

      defaultExportRows = validKeys
      .map (key) =>
        row = "#{key}: #{key}"

        start = char
        end = start + row.length

        defaultExportNode
        .declaration
        .properties
        .push
          type: 'Property'
          start: start
          end: end
          method: false
          shorthand: false
          computed: false
          key:
            type: 'Identifier'
            start: start
            end: start + key.length
            name: key
          value:
            type: 'Identifier'
            start: start + key.length + 2
            end: end
            name: key
          kind: 'init'

        char += row.length + (2 + indent.length) # ',\n\t'.length

        row

      .concat invalidKeys.map (key) => "#{key}": "#{JSON.stringify data[key]}"

      code += "export default {\n${indent}${defaultExportRows.join(`,\n${indent}`)}\n};";
      ast.body.push defaultExportNode

      end = code.length

      defaultExportNode.declaration.end = end - 1
      defaultExportNode.end = end

    ast.end = code.length

    {
      ast
      code
      map:
        mappings: ''
    }