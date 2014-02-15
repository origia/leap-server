_  = require 'underscore'
WebSocketServer = require('ws').Server
logger = require './logger'

class LeapWSServer
  clients: {}
  currentId: 0
  lastSentMessageTime: new Date()

  constructor: (options) ->
    @initialize options || {}

  initialize: (options) ->
    @minTimeInterval = options.minTimeInterval || 0
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
    currentTime = new Date()
    return unless currentTime - @lastSentMessageTime > @minTimeInterval
    _.each @clients, (client) ->
      client.send data
    @lastSentMessageTime = currentTime

module.exports = LeapWSServer
