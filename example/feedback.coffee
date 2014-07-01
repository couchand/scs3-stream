# feedback driver
# the holy grail, one simple end-to-end test of everything

midi = require 'midi'

inp = new midi.input()
inp.openPort 1
input = midi.createReadStream inp

outp = new midi.output()
outp.openPort 1
output = midi.createWriteStream outp

parser = require '../src'
parse = parser 'scs3m'

model = require '../src/model/scs3m'
scs3m = new model.SCS3m()

input
  .pipe parse
  .pipe scs3m
  .pipe output
