import strutils
import sequtils
import "string/betterString"
import "num/sugar"

const J   = 'J'
const I   = 'I'
const Q   = 'Q'
const A_Z: string = ${'A'..'Z'}
const CHARS: seq[char] = A_Z.noWhiteSpace.chars

type
  PlayfairPassphrase* = ref object of RootObj
    data*  : array[5,array[5, char]]
    dropQ* : bool

  Coords = ref object of RootObj
    x,y*: int

iterator coords*( my: PlayfairPassphrase ): tuple[value: char, coords: Coords] =
  for x in 0..4:
    for y in 0..4:
      yield( my.data[x][y], Coords(x: x, y: y) )

proc next*( my: PlayfairPassphrase ): Coords =
  for val, coords in my.coords:
    if not val.isUpper: return coords
  raise newException(ValueError, "the requested coordinates were invalid")

proc contains*( my: PlayfairPassphrase, letter: char ): bool =
  for val, coords in my.coords:
    if val == letter: return true
  return false

proc coordsFor*( my: PlayfairPassphrase, letter: char ): Coords =
  for val, coords in my.coords:
    if val == letter: return coords
  raise newException(ValueError, "the requested coordinates were invalid")

proc at*(my: PlayfairPassphrase, coords: Coords): char =
  return my.data[coords.x][coords.y]

proc sameRow*( my: PlayfairPassphrase, left: char, right: char ): bool =
  return my.coordsFor(left).x == my.coordsFor(right).x

proc sameCol*( my: PlayfairPassphrase, left: char, right: char ): bool =
  return my.coordsFor(left).y == my.coordsFor(right).y

proc nextRow*( coords: Coords ): Coords =
  if coords.x == 4 : return Coords(x: 0, y: coords.y)
  else             : return Coords(x: coords.x + 1, y: coords.y)

proc nextCol*( coords: Coords ): Coords =
  if coords.y == 4 : return Coords(x: coords.x, y: 0)
  else             : return Coords(x: coords.x, y: coords.y + 1)

proc prevRow*( coords: Coords ): Coords =
  if coords.x == 0 : return Coords(x: 4, y: coords.y)
  else             : return Coords(x: coords.x - 1, y: coords.y)

proc prevCol*( coords: Coords ): Coords =
  if coords.y == 0 : return Coords(x: coords.x, y: 4)
  else             : return Coords(x: coords.x, y: coords.y - 1)

proc toString*( coords: Coords ): string =
  @["X: ", $coords.x, " Y: ",  $coords.y, "\n"].join

proc transpose*( my: PlayfairPassphrase, left: char, right: char ): tuple[left: Coords, right: Coords] =
  var originLeft  = my.coordsFor(left)
  var originRight = my.coordsFor(right)
  return ( 
    left : Coords( x: originLeft.x,  y: originRight.y), 
    right: Coords( x: originRight.x, y: originLeft.y )
  )

proc push*( passphrase: var PlayfairPassphrase, letters: seq[char]) =
  for letter in letters:
    if passphrase.dropQ and letter == Q: continue
    if not passphrase.dropQ            and 
        ( letter == I or letter == J ) and 
        ( passphrase.contains(I)       or 
          passphrase.contains(J) ): continue
    if passphrase.contains(letter): continue
    var coords = passphrase.next
    passphrase.data[coords.x][coords.y]= letter


proc print*(my: PlayfairPassphrase) =
  var rows = "\n"
  for val, coords in my.coords:
    rows.add val
    if coords.y == 4 : rows.add "\n"
  echo rows

proc createPassphrase*(key: string, dropQ = false): PlayfairPassphrase =
  var my = PlayfairPassphrase(dropQ: dropQ)
  my.push key.noWhiteSpace.toUpper.chars
  my.push CHARS
  return my
