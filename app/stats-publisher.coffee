_      = require 'underscore'
logger = require './logger'
config = require '../config/config.json'
url    = require 'url'
http   = require 'http'

options = _.extend({
  method: 'POST'
}, url.parse(config.apiEndpoint))

postStats = (data) ->
  data = JSON.stringify data unless _.isString(data)
  logger.debug 'starting http request'
  options.headers =
    'Content-Length': data.length
  req = http.request options, (res) ->
    logger.debug "STATUS: #{res.statusCode}"
  req.write data
  req.end()

module.exports =
  postStats: postStats
