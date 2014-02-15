logger = require './logger'
leap = require './leap'

WebSocketServer = require('ws').Server

wss = new WebSocketServer({port: 8080})

leap.on 'move', ->
  logger.debug 'move event'

