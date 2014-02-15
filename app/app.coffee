_  = require 'underscore'
leap = require './leap'
wsHandlers = require './ws-handlers'

WebSocketServer = require('ws').Server

wss = new WebSocketServer({port: 8080})

_.each wsHandlers, (handler, evt) ->
  wss.on evt, handler
