router = require 'koa-router'
module.exports = class JoiRide
  joi = @joi = require 'joi'
  @enjoi = require 'enjoi'
  @validate = (schemas, options = {}) ->
    (next) ->
      try
        for key of schemas
          result = yield do (key) =>
            (callback) =>
              joi.validate @[key], schemas[key], options, callback
          unless key is 'session'
            @[key] = result
      catch error
        @throw 400, error
      yield next
  for method of router::
    do (method) =>
      @[method] = (args...) ->
        args.$method = method
        args
  constructor: (app) ->
    unless @ instanceof JoiRide
      return new JoiRide app
    @router = router()
    for method of @
      if @router[@[method]?.$method] instanceof Function
        @router[@[method].$method].apply @router, [method].concat @[method]
    app.use @router.routes()
