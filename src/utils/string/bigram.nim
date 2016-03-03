import strutils
import sequtils

import "betterString"
import "../num/sugar"

proc toBigrams*(str: string, filler = 'X'): seq =
  var runes   = str.noWhiteSpace.toUpper
  var left    = newSeq[char](0)
  var right   = newSeq[char](0)

  for i, c in runes.chars:
    if i == 0 : 
      left.add(c)
      continue
    if i.evenlyDivisibleBy(2): left.add(c)
    else: right.add(c)

  if ( left.len > right.len ): right.add(filler)

  return zip(left, right)