# mygenerator.js
Parser = (require "jison").Parser

# a grammar in JSON
grammar = require './grammar'

# `grammar` can also be a string that uses jison's grammar format
parser = new Parser grammar

# generate source, ready to be written to disk
# parserSource = parser.generate()

# you can also use the parser directly from memory
module.exports = (str) ->
  parser.parse str
