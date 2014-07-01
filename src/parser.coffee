# parse an incoming MIDI message

{NOTE_UP, NOTE_DOWN, CONTROL_CHANGE} = require './constants'

hi = (byte) -> byte & 0xf0
lo = (byte) -> byte & 0x0f

module.exports = (map) ->
  parse = (message) ->
    type = hi message[0]
    channel = lo message[0]
    number = message[1]
    value = message[2]

    control = switch type
      when NOTE_UP
        value = 0
        map.notes[message[1]]
      when NOTE_DOWN
        value = 1
        map.notes[message[1]]
      when CONTROL_CHANGE
        map.ccs[message[1]]

    {channel, control, value} if control?
