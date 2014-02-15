_      = require 'underscore'
logger = require './logger'
Leap   = require 'leapjs'

class LeapHandler
  _events:
    'move': ->

  controller: new Leap.Controller()
  lastEventTime: 0

  constructor: (options) ->
    options ||= {}
    @minTimeInterval = options.minTimeInterval || 0
    @_initEvents()
    @controller.connect() unless options.noAutoConnect

  _initEvents: ->
    @controller.on 'connect', (=> @handleConnect())
    @controller.on 'deviceConnected', (=> @handleDeviceConnected())
    @controller.on 'deviceDisconnected', (=> @handleDeviceDisconnected())
    @controller.on 'frame', ((frame) => @handleFrame(frame))

  handleConnect: ->
    logger.debug 'leap connection succeeded'

  handleDeviceConnected: ->
    logger.debug 'leap device connected'

  handleDeviceDisconnected: ->
    logger.debug 'leap device disconnected'

  handleFrame: (frame) ->
    if frame.valid && frame.pointables.length > 1
      @trigger 'move', frame

  connect: -> @controller.connect()

  on: (evtName, handler) ->
    @_events[evtName] = handler

  trigger: (evtName, args...) ->
    currentTime = new Date()
    return unless currentTime - @lastEventTime > @minTimeInterval
    @lastEventTime = currentTime
    return unless @_events[evtName]?
    @_events[evtName](args...)


module.exports = LeapHandler
