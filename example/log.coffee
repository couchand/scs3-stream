# a simple logging test driver

midi = require 'midi'

inp = new midi.input()
inp.openPort 1
input = midi.createReadStream inp

parser = require '../src'
parse = parser 'scs3m'

stream = require 'readable-stream'
serialize = new stream.Transform()
serialize._writableState.objectMode = yes
serialize._transform = (chunk, enc, cb) ->
  @push JSON.stringify chunk, null, 2
  cb()

input
  .pipe parse
  .pipe serialize
  .pipe process.stdout
