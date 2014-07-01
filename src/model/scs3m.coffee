# SCS.3m model

stream = require 'readable-stream'

command = require '../command/scs3m'
map = require '../map/scs3m'

MODE_FINGER_TRACE = 0
MODE_BOOST_CUT    = 1
MODE_PEAK         = 2
MODE_SPREAD       = 3

class LEDArray
  constructor: (@cc, @channel=0) ->
    @_count = unless @cc in [0x0a, 0x4a, 0x51] then 7 else 11 # S11
    @setModeFingerTrace()

  setModeFingerTrace: ->
    @_mode = MODE_FINGER_TRACE
  setModeBoostCut: ->
    @_mode = MODE_BOOST_CUT
  setModePeak: ->
    @_mode = MODE_PEAK
  setModeSpread: ->
    @_mode = MODE_SPREAD

  mapValue: (val) ->
    return 0 if val is 0 and @_mode in [MODE_SPREAD, MODE_PEAK]

    if @_mode is MODE_SPREAD
      if @_count is 7
        switch on
          when val < 32 then 1
          when val < 64 then 2
          when val < 96 then 3
          else               4
      else # @_count is 11
        switch on
          when val < 22  then 1
          when val < 43  then 2
          when val < 64  then 3
          when val < 85  then 4
          when val < 106 then 5
          else                6
    else # @_mode in [MODE_FINGER_TRACE, MODE_BOOST_CUT, MODE_PEAK]
      if @_count is 7
        switch on
          when val < 19  then 1
          when val < 37  then 2
          when val < 55  then 3
          when val < 73  then 4
          when val < 91  then 5
          when val < 109 then 6
          else                7
      else # @_count is 11
        switch on
          when val < 12  then 1
          when val < 24  then 2
          when val < 35  then 3
          when val < 47  then 4
          when val < 58  then 5
          when val < 70  then 6
          when val < 81  then 7
          when val < 93  then 8
          when val < 104 then 9
          when val < 116 then 10
          else                11

  # val in [0..127]
  setValue: (val) ->
    count = @mapValue val
    base = switch @_mode
      when MODE_FINGER_TRACE then 0x00
      when MODE_BOOST_CUT    then 0x14
      when MODE_PEAK         then 0x28
      when MODE_SPREAD       then 0x3c

    data = base + count
    header = 0xb0 + @channel

    [header, @cc, data]

class Fader extends LEDArray
  constructor: (@cc, @channel=0) ->
    super

splitName = (name) ->
  name.split '/'

class SCS3m extends stream.Transform
  constructor: (@channel=0, opts={}) ->
    if typeof @channel is 'object'
      opts = @channel
      @channel = 0

    options =
      objectMode: yes
    for own k, v of opts when k isnt 'objectMode'
      options[k] = v

    super options

    @on 'pipe', ->
      flatMode = command.setMode command.modes.flat
      @push flatMode[0]
      @push flatMode[1]

    for index, control of map.out.fader
      cc = map.OFFSET_FADER + +index
      @_set splitName(control), new Fader cc, @channel

    for index, control of map.out.vu
      cc = map.OFFSET_VU + +index
      @_set splitName(control), new LEDArray cc, @channel

    # TODO: buttons

    @_initialize()

  _initialize: ->
    @xfade        .setModeBoostCut()
    @left .vu     .setModePeak()
    @right.vu     .setModePeak()
    @left .level  .setModePeak()
    @right.level  .setModePeak()
    @left .balance.setModeBoostCut()
    @right.balance.setModeBoostCut()
    @left .low    .setModeBoostCut()
    @right.low    .setModeBoostCut()
    @left .mid    .setModeBoostCut()
    @right.mid    .setModeBoostCut()
    @left .high   .setModeBoostCut()
    @right.high   .setModeBoostCut()

  _set: (name, value, obj=this) ->
    return unless name?.length > 0

    return obj[name[0]] = value if name.length is 1

    child = obj[name.shift()] ?= {}
    @_set name, value, child

  _get: (name, obj=this) ->
    return unless name?.length > 0

    return obj[name[0]] if name.length is 1

    child = obj[name.shift()]
    @_get name, child

  handleMessage: ({channel, control, value}) ->
    return if channel? and channel isnt @channel

    child = @_get splitName(control)
    child.setValue value if child

  _transform: (chunk, enc, cb) ->
    return cb() unless chunk.control and chunk.value

    message = @handleMessage chunk
    @push message if message

    cb()

module.exports = {LEDArray, SCS3m}
