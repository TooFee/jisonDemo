import coffee2 from 'cfx.rollup-plugin-coffee2'

export default
  input: './index.js'
  output:
    file: './dist/bundle.js'
    format: 'cjs'
  plugins: [
    coffee2
      bare: true
      sourceMap: true
  ]