# system status

midi = require 'midi'
out = new midi.output()
out.openPort 1
output = midi.createWriteStream out

command = require '../src/command/scs3m'
flat = command.setMode command.modes.flat
out.sendMessage flat[0]
out.sendMessage flat[1]

model = require '../src/model/scs3m'
scs3m = new model.SCS3m()

scs3m.pipe output

os = require 'os'

setInterval (->
  free = os.freemem()
  total = os.totalmem()
  scs3m.write
    control: 'left/vu'
    value: 127 - (127 * free / total)

  {heapUsed, heapTotal} = process.memoryUsage()
  scs3m.write
    control: 'right/vu'
    value: 127 * heapUsed / heapTotal

  console.log "os", free, total
  console.log "proc", heapUsed, heapTotal
), 100
