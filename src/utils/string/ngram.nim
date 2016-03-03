import strutils
import sequtils

import "betterString"
import "../num/sugar"

type
  Ngrams* = object
    list*   : seq[string]
    width*  : int
    filler* : char


proc tail*(my: var Ngrams): string =
  ## returns the last ngram in a collection of Ngrams
  return my.list[my.list.len-1]

proc `++`*(my: var Ngrams, c: char) =
  ## add a character to the ngram-list
  ## this operation is width aware, so will overflow to the next index if need be
  if my.tail.len == my.width: my.list.add( "" )
  my.list[my.list.len-1].add(c)

iterator each*(my: Ngrams): string =
  ## allows you to iterate over an Ngrams instance
  for ngram in my.list: yield(ngram) 

proc toNgrams*(str: string, width: int, overlapping = true, filler = 'X'): Ngrams =
  ## converts a string to a set of N-width engrams
  ## example: 
  ##  str.toNgrams(2) @['IA', 'MN', 'OW', 'AN', 'NG', 'RA', 'MX']
  ##  where X is the filler character
  let runes   = str.noWhiteSpace.toUpper

  var ngrams: Ngrams

  ngrams = Ngrams( list: @[""], width: width, filler: filler )
  

  for i, rune in runes:
    if not overlapping:
      ngrams ++ rune
    else:
      for n in i..i+width-1 :
        if n < runes.len  : ngrams ++ runes[n]
        else              : break
      if i+width-1 > runes.len : break

  while ngrams.tail.len < ngrams.width: ngrams ++ filler

  return ngrams
    

 