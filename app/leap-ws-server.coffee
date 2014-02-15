_               = require 'underscore'
WebSocketServer = require('ws').Server
logger          = require './logger'
statsPublisher  = require './stats-publisher'

class LeapWSServer
  clients: {}
  currentId: 0

  constructor: (options) ->
    @initialize options || {}

  initialize: (options) ->
    server = new WebSocketServer(options)
    server.on 'connection', ((client) => @addClient(client))

  addClient: (client) ->
    if 'x-token' of client.upgradeReq.headers
      token = client.upgradeReq.headers['x-token']
      id = @currentId++
      logger.debug "client connected with id #{id}"
      @clients[id] =
        connection: client
        token: token
      client.on 'close', (=> @removeClient(id))
      logger.debug 'connection completed'
    else
      logger.debug 'connection refused'
      client.close()

  removeClient: (id) ->
    logger.debug "client with id #{id} disconnected"
    delete @clients[id]

  broadCast: (data) ->
    logger.debug 'publishing leap data to mobile device'
    _.each @clients, (client) ->
      client.connection.send JSON.stringify(data)

  publishStats: (data) ->
    logger.debug 'publishing stats'
    _.each @clients, (client) ->
      statsPublisher.postStats _.extend(data, token: client.token)


module.exports = LeapWSServer
