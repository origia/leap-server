_  = require 'underscore'
WebSocketServer = require('ws').Server
logger = require './logger'

class LeapWSServer
  clients: {}
  currentId: 0

  constructor: (options) ->
    @initialize options || {}

  initialize: (options) ->
    server = new WebSocketServer(options)
    server.on 'connection', ((client) => @addClient(client))

  addClient: (client) ->
    id = @currentId++
    logger.debug "client connected with id #{id}"
    @clients[id] = client
    client.on 'close', (=> @removeClient(id))

  removeClient: (id) ->
    logger.debug "client with id #{id} disconnected"
    delete @clients[id]

  broadCast: (data) ->
    _.each @clients, (client) ->
      client.send data

module.exports = LeapWSServer
