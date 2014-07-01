# SCS.3m control map

OFFSET_FADER   = 0x00
OFFSET_VU      = 0x0c

OFFSET_BUTTON  = 0x00
OFFSET_SUPER   = 0x51
OFFSET_LOGO    = 0x69

controls =

  # faders
  #   start at cc 0x00
  fader: [
    'left/balance'
    'right/balance'
    'left/low'
    'right/low'
    'left/mid'
    'right/mid'
    'left/high'
    'right/high'
    'left/level'
    'right/level'
    'xfade'
  ]

  # buttons
  #   start at note 0x00
  button: [
    'left/a'
    'right/a'
    'left/b'
    'right/b'
    'left/c'
    'right/c'
    'left/d'
    'right/d'
    'left/monitor'
    'right/monitor'
    'left/fx'
    'right/fx'
    'left/eq'
    'right/eq'
    'master'
    'right/input'
    'left/input'
  ]

  # fader sections that act as buttons
  #   start at note 0x51
  super: [
    'left/balance/a'
    'left/balance/b'
    'left/balance/c'
    'right/balance/a'
    'right/balance/b'
    'right/balance/c'
    'left/low/b'
    'left/low/a'
    'right/low/b'
    'right/low/a'
    'left/mid/b'
    'left/mid/a'
    'right/mid/b'
    'right/mid/a'
    'left/high/b'
    'left/high/a'
    'right/high/b'
    'right/high/a'
    'left/level/b'
    'left/level/a'
    'right/level/b'
    'right/level/a'
    'xfade/a'
    'xfade/b'
  ]

  # vu meter led arrays
  #   start at cc 0x0c
  vu: [
    'left/vu'
    'right/vu'
  ]

  # logo led
  #   start at note 0x69
  logo: [
    'logo'
  ]

load = (map) ->
  ccs   = []
  notes = []

  for index, name of map.fader
    ccs[OFFSET_FADER + +index] = name
  for index, name of map.vu
    ccs[OFFSET_VU + +index] = name

  for index, name of map.button
    notes[OFFSET_BUTTON + +index] = name
  for index, name of map.super
    notes[OFFSET_SUPER + +index] = name
  for index, name of map.logo
    notes[OFFSET_LOGO + +index] = name

  {notes, ccs}

module.exports = {
  in: load controls
  out: controls

  OFFSET_FADER
  OFFSET_VU
  OFFSET_BUTTON
  OFFSET_SUPER
  OFFSET_LOGO
}
