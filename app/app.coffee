leap = require './leap'

WebSocketServer = require('ws').Server

wss = new WebSocketServer({port: 8080})

wss.on 'connection', (ws) ->
