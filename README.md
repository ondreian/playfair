# Playfair [![Build Status](https://travis-ci.org/ondreian/playfair.svg?branch=master)](https://travis-ci.org/ondreian/playfair)

This is an implementation of the [Playfair cipher](https://en.wikipedia.org/wiki/Playfair_cipher) in [Nim](http://nim-lang.org/)

```nim
var cipher = createPlayfair(PASSWORD, TEXT).encrypt

var plaintext = cipher.decrypt
```

It is meant to be a learning example, and perhaps useful for some crypto challenges.  Checkout the source for the other options:

  1) Option: make I || J occupy the same space versus dropping Q

  2) Pad/Drop duplicates with X
