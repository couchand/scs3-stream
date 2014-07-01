# mouse driver

midi = require 'midi'

inp = new midi.input()
inp.openPort 1
input = midi.createReadStream inp

parser = require '../src'
parse = parser 'scs3m'

x11 = require 'x11'
client = x11.createClient ->
  root = client.display.screen[0].root

  width = 800
  height = 600

  client.GetGeometry root, (err, result) ->
    throw err if err

    {width, height} = result

  move = (sx, sy) ->
    client.WarpPointer 0, root, 0, 0, 0, 0, sx, sy

  moveX = (x) ->
    sx = Math.floor width * x / 127
    client.QueryPointer root, (err, result) ->
      throw err if err

      move sx, result.rootY

  moveY = (y) ->
    sy = Math.floor height * (127 - y) / 127
    client.QueryPointer root, (err, result) ->
      throw err if err

      move result.rootX, sy

  click = ->
    client.require 'xtest', (t) ->
      t.FakeInput t.ButtonPress,   1, 0, root, 0, 0
      t.FakeInput t.ButtonRelease, 1, 0, root, 0, 0

  parse.on 'data', (d) ->
    switch d.control
      when 'xfade'   then moveX d.value
      when 'left/level' then moveY d.value
      when 'left/monitor'
        click() if d.value

  # let everything warm up
  setTimeout (->
    input.pipe parse
  ), 1000
