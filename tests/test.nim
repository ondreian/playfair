import unittest, strutils
import "../src/playfair"
import "../src/utils/passphrase"
#
# TEST CASE 1
#
const TEXT1     = "hello world"
const PASSWORD1 = "testing"
const CIPHER1   = "PAKYPVPUMC"
let p1          = createPlayfair(PASSWORD1, TEXT1, false)
let p2          = createPlayfair(PASSWORD1, p1.encrypt, false)
#
# TEST CASE  2
#
const TEXT2     = "Hide the gold in the tree stump"
const PASSWORD2 = "playfair example"
const CIPHER2   = "BMODZBXDNABEKUDMUIXMMOUVIF"
let p3          = createPlayfair(PASSWORD2, TEXT2)
let p4          = createPlayfair(PASSWORD2, p3.encrypt)

suite "...encryption":
  test TEXT1:
    echo p1.encrypt, " is ", CIPHER1
    check p1.encrypt == CIPHER1
  
  test TEXT2:
    echo p3.encrypt, " is ", CIPHER2
    check p3.encrypt == CIPHER2

suite "...decryption":
  test TEXT1:
    var plaintext = p2.decrypt
    echo plaintext, " is ", p1.text
    for i, letter in p1.text:
      if plaintext[i] == 'X': continue
      check plaintext[i] == letter

  test TEXT2:
    var plaintext = p4.decrypt
    echo plaintext, " is ", p3.text
    for i, letter in p3.text: check plaintext[i] == letter