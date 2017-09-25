# mygenerator.js
import { Parser } from "jison"

# a grammar in JSON
import grammar from './grammar'

# `grammar` can also be a string that uses jison's grammar format
parser = new Parser grammar

# generate source, ready to be written to disk
# parserSource = parser.generate()

# you can also use the parser directly from memory
export default calc = (str) ->
  parser.parse str
