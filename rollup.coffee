import coffee2 from 'rollup-plugin-coffee2'

export default
  input: './index.js'
  output:
    file: './dist/bundle.js'
    format: 'cjs'
  plugins: [
    coffee2
      # defaults
      bare: true
      extensions: [
        '.coffee'
        # '.litcoffee'
      ]
      # version: 'auto'
      version: 2
      # between )
      sourceMap: true
  ]