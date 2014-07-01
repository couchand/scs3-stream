# SCS.3m commands

MANUFACTURER_ID = [0x00, 0x01, 0x60]

makePart = (part, data) ->
  [
    0xf0
    MANUFACTURER_ID[0]
    MANUFACTURER_ID[1]
    MANUFACTURER_ID[2]
    part
    data
    0xf7
  ]

module.exports =

  # set the mode
  #   0: semi-auto
  #   1: auto
  #   2: flat
  setMode: (mode) ->
    partOne = makePart 0x10, mode & 0x01
    partTwo = makePart 0x15, (mode & 0x02) >> 1
    [partOne, partTwo]

  modes:
    semiAuto: 0
    auto: 1
    flat: 2
