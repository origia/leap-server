logger = require './logger'
LeapHandler = require './leap'
LeapWSServer = require './leap-ws-server'
statsPublisher = require './stats-publisher'

server = new LeapWSServer
  port: 8080

leap = new LeapHandler
  minTimeInterval: 3000

dir =
  none:  0x00
  up:    0x01
  down:  0x02
  left:  0x04
  right: 0x08

getData = (frame) ->
  dirs = [dir.none, dir.up, dir.down]
  up = dirs[Math.floor Math.random() * 3]
  left = if Math.random() < 0.5 then dir.left else dir.right
  up | left

leap.on 'move', (frame) ->
  data =
    relativePosition: getData(frame)
  statsPublisher.postStats data
  server.broadCast JSON.stringify(data)
