import strutils
import sequtils
import docopt

import "utils/string/betterString"
import "utils/string/bigram"
import "utils/string/ngram"
import "utils/passphrase"
import "utils/analyzer"

const X = 'X'

type 
  Playfair* = ref object of RootObj
    pass*    : PlayfairPassphrase 
    text*    : string
    safe*    : string
    cipher*  : string
    padWithX : bool

proc createPlayfair*(pass: string, text: string, padWithX = true, dropQ = false): Playfair =
  return Playfair( 
    pass     : pass.createPassphrase(dropQ), 
    text     : text.noWhiteSpace.toUpper, 
    padWithX : padWithX
  )

proc encrypt*( my: Playfair ): string =
  my.safe = ""
  for i, letter in my.text:
    if i != 0 and my.text[i-1] == letter: 
      my.safe.add X
      if not my.padWithX: continue
    my.safe.add letter

  var bigrams = my.safe.toBigrams

  var ciphertext = ""

  for i, bigram in bigrams:

    if my.pass.sameRow(bigram.a, bigram.b):
      ciphertext.add my.pass.at my.pass.coordsFor(bigram.a).nextCol
      ciphertext.add my.pass.at my.pass.coordsFor(bigram.b).nextCol
      continue

    if my.pass.sameCol(bigram.a, bigram.b):
      ciphertext.add my.pass.at my.pass.coordsFor(bigram.a).nextRow
      ciphertext.add my.pass.at my.pass.coordsFor(bigram.b).nextRow
      continue

    let pair = my.pass.transpose(bigram.a, bigram.b)
    ciphertext.add my.pass.at pair.left
    ciphertext.add my.pass.at pair.right

  my.cipher = ciphertext
  return my.cipher

proc decrypt*( my: Playfair ): string =
  var bigrams = my.text.toBigrams

  var plaintext = ""
  
  for i, bigram in bigrams:
    if bigram.a == bigram.b:
      bigrams[i] = (a: bigram.a, b: X)

  for i, bigram in bigrams:
    if my.pass.sameRow(bigram.a, bigram.b):
      plaintext.add my.pass.at my.pass.coordsFor(bigram.a).prevCol
      plaintext.add my.pass.at my.pass.coordsFor(bigram.b).prevCol
      continue

    if my.pass.sameCol(bigram.a, bigram.b):
      plaintext.add my.pass.at my.pass.coordsFor(bigram.a).prevRow
      plaintext.add my.pass.at my.pass.coordsFor(bigram.b).prevRow
      continue

    let pair = my.pass.transpose(bigram.a, bigram.b)
    plaintext.add my.pass.at pair.left
    plaintext.add my.pass.at pair.right

  if my.padWithX : plaintext = plaintext.split(X).join("")
  my.text = plaintext
  return my.text

when isMainModule:
  const MENU = """

  Playfair Cipher

  Usage:
    playfair encrypt --pass <pass> --input <input> [--output <output>]
    playfair decrypt --pass <pass> --input <input> [--output <output>]

  Options:

    -o --output        File that the output goes to 
    -i --input         File that contains input
    -d --dropQ         Drop Q's instead of making I & J occupy the same space
    -p --pass          The password to use on the file
    -v --version       Show version.
    -h --help          Show this screen.

  """
  var args  = docopt(MENU, version = "Playfair 0.0.1")
  let input = $args["<input>"]
  let pass  = $args["<pass>"]
  let text  = readFile input
  echo createPlayfair(pass, text, args["--dropQ"]).encrypt