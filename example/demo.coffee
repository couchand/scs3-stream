# a little led demo

midi = require 'midi'

out = new midi.output()
out.openPort 1
outstream = midi.createWriteStream out

command = require '../src/command/scs3m'

flatMode = command.setMode command.modes.flat
outstream.write flatMode[0]
outstream.write flatMode[1]

model = require '../src/model/scs3m'

leds = for channel in [0x00..0x0d] when channel isnt 0x0b
  new model.LEDArray channel

time = 0
schedule = (d) ->
  task = ->
    outstream.write led.setValue d for led in leds
  time += 2
  setTimeout task, time

main = ->
  setTimeout (->
    for led in leds
      led.setModeFingerTrace()
  ), time
  
  schedule i for i in [0..127]
  schedule i for i in [127..0]

  setTimeout (->
    for led in leds
      led.setModeBoostCut()
  ), time
  
  schedule i for i in [0..127]
  schedule i for i in [127..0]

  setTimeout (->
    for led in leds
      led.setModePeak()
  ), time
  
  schedule i for i in [0..127]
  schedule i for i in [127..0]

  setTimeout (->
    for led in leds
      led.setModeSpread()
  ), time
  
  schedule i for i in [0..127]
  schedule i for i in [127..0]

  setTimeout (->
    time = 0
    main()
  ), time

setTimeout main, 1000
