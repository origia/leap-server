_  = require 'underscore'
logger = require './logger'
leap = require './leap'

WebSocketServer = require('ws').Server

wss = new WebSocketServer({port: 8080})

currentId = 0
receivers = {}

leap.on 'move', (frame) ->
  logger.debug frame.dump()
  data =
    relativePosition: Math.floor Math.random() * 8
  textData = JSON.stringify data
  _.each receivers, (ws) ->
    ws.send textData

wss.on 'connection', (ws) ->
  id = currentId++
  logger.debug "client connected with id #{id}"
  receivers[id] = ws
  ws.on 'close', ->
    delete receivers[id]
