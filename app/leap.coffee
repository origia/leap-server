_  = require 'underscore'
logger = require './logger'
Leap = require 'leapjs'

class LeapHandler
  _events:
    'move': ->

  constructor: (@controller) ->
    @controller.on 'connect', (=> @handleConnect())
    @controller.on 'deviceConnected', (=> @handleDeviceConnected())
    @controller.on 'deviceDisconnected', (=> @handleDeviceDisconnected())
    @controller.on 'frame', ((frame) => @handleFrame(frame))

  handleConnect: ->
    logger.debug 'connection succeeded'

  handleDeviceConnected: ->
    logger.debug 'device connected'

  handleDeviceDisconnected: ->
    logger.debug 'device disconnected'

  handleFrame: (frame) ->
    if frame.valid && frame.pointables.length > 1
      @trigger 'move'

  connect: -> @controller.connect()

  on: (evtName, handler) ->
    @_events[evtName] = handler

  trigger: (evtName, args...) ->
    return unless @_events[evtName]?
    @_events[evtName](args)


controller = new LeapHandler(new Leap.Controller())
controller.connect()

module.exports = controller
