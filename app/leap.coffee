Leap = require 'leapjs'

controller = new Leap.Controller()

controller.on 'connect', ->
  console.log 'connection done'

controller.on 'deviceConnected', ->
  console.log 'connected'

controller.on 'deviceDisconnected', ->
  console.log 'disconnected'

controller.on 'frame', (frame) ->


controller.connect()

exports.leap = controller
