import strutils

proc chars*(str: string): seq[char] =
  var list = newSeq[char](str.len)
  for i, c in str: list[i]=c
  return list

proc noWhitespace*(str: string): string =
  var list = ""
  for i, c in str: 
    if c.isAlpha: 
      list.add(c)
  return list