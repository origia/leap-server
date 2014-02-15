Leap = require 'leapjs'

controller = new Leap.Controller()

controller.on 'connect', ->
  console.log 'connection done'

controller.on 'deviceConnected', ->
  console.log 'connected'

controller.on 'deviceDisconnected', ->
  console.log 'disconnected'

controller.on 'frame', (frame) ->
  if frame.id % 100 == 0
    console.log frame.fingers

controller.connect()

exports.leap = controller
