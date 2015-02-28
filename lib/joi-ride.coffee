module.exports = class JoiRide extends require 'koa-router'
  @validate = require 'koa-joi'
  @joi = require 'joi'
  for own method of @::
    @[method] = (...args) ->
      args.$method = method
      args
  constructor: (app) ->
    super app
    for method of @
      if @[@[method]?.$method] instanceof Function
        @[@[method].$method].apply @, [method].concat @[method]
