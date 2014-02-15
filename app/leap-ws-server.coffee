_               = require 'underscore'
WebSocket       = require('ws')
WebSocketServer = WebSocket.Server
logger          = require './logger'
statsPublisher  = require './stats-publisher'

class LeapWSServer
  clients: {}

  constructor: (options) ->
    @initialize options || {}

  initialize: (options) ->
    server = new WebSocketServer(options)
    server.on 'connection', ((client) => @addClient(client))

  addClient: (client) ->
    if 'x-token' of client.upgradeReq.headers
      token = client.upgradeReq.headers['x-token']
      logger.debug "client connected with token #{token}"
      if token of @clients
        @clients[token].connection = client
      else
        @clients[token] =
          connection: client
          token: token
      client.on 'close', (=> @removeClient(token))
      logger.debug 'connection completed'
    else
      logger.debug 'connection refused'
      client.close()

  removeClient: (token) ->
    logger.debug "client with token #{token} disconnected"

  broadCast: (data) ->
    logger.debug 'publishing leap data to mobile device' if @clients.length > 0
    _.each @clients, (client) ->
      if client.readyState == WebSocket.OPEN
        client.connection.send JSON.stringify(data)

  publishStats: (data) ->
    logger.debug 'publishing stats' if @clients.length > 0
    _.each @clients, (client) ->
      statsPublisher.postStats _.extend(data, token: client.token)


module.exports = LeapWSServer
