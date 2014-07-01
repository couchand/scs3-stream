scs3 stream
===========

streaming i/o to SCS.3m and SCS.3d devices

  * introduction
  * getting started
  * documentation
  * more information

introduction
============

The SCS 3-series are a pair of novel programmable MIDI DJ controllers,
the 3m representing a DJ mixer and the 3d representing a turntable.
They feature LED feedback and multi-touch surfaces, all handled over
standard MIDI over USB.

This module offers two types of transform streams which together will
let you control the SCS 3-series without having to worry about MIDI
messages, Control Changes and the like.  Simply send and receive
logical command messages which are translated to the 3-series control
codes.

getting started
===============

**scs3-stream** is a node.js package, so you'll have to have that set
up first.  Then install with npm:

    npm install --save scs3-stream

The easiest way to get MIDI I/O is the excellent `midi` package, so
install that, too:

    npm install --save midi

Now you can start playing:

```coffeescript
midi = require 'midi'
out = new midi.output()
out.openPort 2
output = midi.createReadStream midi

scs3 = require 'scs3-stream'
scs3m = scs3.model 'scs3m'
scs3m.pipe output

scs3m.write
  channel: 0
  control: xfade
  value: 127
```

documentation
=============

A pair of symmetric transform streams make up the bulk of this module.
The `parse` stream parses MIDI messages and outputs logical messages,
and the `model` stream takes logical messages and produces MIDI ones.

The MIDI messages are assumed to be of the form produced by the `midi`
module, i.e., an array of numbers.

The logical messages this module produces and consumes are simple
objects with three properties:

  * **channel**: MIDI channel the device is using
  * **control**: name of the control (see below)
  * **value**: fader value, one or zero for buttons

The controls are named based on their position and their typical use.

more information
================

Documentation on the SCS 3-series seems to be pretty scant online
these days.  What I found is included here in the `references` folder.
If you find any other good resources please let me know.

##### ╭╮☲☲☲╭╮ #####
