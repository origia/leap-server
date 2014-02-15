logger = require './logger'
leap = require './leap'
LeapWSServer = require('./leap-ws-server')

server = new LeapWSServer({port: 8080})

leap.on 'move', (frame) ->
  logger.debug frame.dump()
  data =
    relativePosition: Math.floor Math.random() * 8
  server.broadCast JSON.stringify(data)
