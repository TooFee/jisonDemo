# import coffee2 from 'rollup-plugin-coffee2'
import coffee2 from './rollupPlugins/coffee'

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