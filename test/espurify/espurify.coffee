import espurify from 'espurify'

import dd from 'ddeyes'

import {
  getAST
  ricffAST
  ASTToCode
} from '../../rollupPlugins/coffee/util'

jsCode = 'import calc from "../../src/calc";'

originalAst = ricffAST getAST jsCode

# dd originalAst

purifiedClone = espurify originalAst

dd purifiedClone
dd ASTToCode originalAst
