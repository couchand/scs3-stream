# scs3 stream

stream = require 'readable-stream'

map = require './map'
parser = require './parser'

class SCS3Stream extends stream.Transform
  constructor: (@parse, opts = {}) ->
    options =
      objectMode: yes
    for own k, v of opts when k isnt 'objectMode'
      options[k] = v

    super options

  _transform: (chunk, enc, cb) ->
    if chunk.length isnt 3
      return cb() # not my problem

    parsed = @parse chunk
    @push parsed if parsed

    cb()

module.exports = scs3stream = (type, opts) ->
  #unless type of map
  #  throw new Error "unknown device type, options are: #{Object.keys map}"

  device = map[type].in
  parse = parser device

  new SCS3Stream parse, opts
