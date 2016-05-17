fs              = require 'fs-extra'
JSDoc           = require 'jsdoc-parse'
streamToPromise = require 'stream-to-promise'
_               = require 'lodash'

doIt = =>
  readDoc = streamToPromise JSDoc src: './node_modules/cylon-i2c/lib/blinkm.js'
  readDoc.then (docs) =>
    docs = JSON.parse docs.toString()
    parsed =
      _(docs)
        .filter kind: 'function'
        .map doc2Schema
        .value()


    console.log JSON.stringify parsed, null, 2


doc2Schema = (doc) =>
  schema =
    name: doc.name
    title: doc.name
    description: doc.description
    type: 'object'
    properties: paramsToProperties doc.params

  return schema

paramsToProperties = (params) =>
  params = _.keyBy params, 'name'
  delete params.cb
  delete params.callback
  _.mapValues params, (param) =>
    paramToProperty param

paramToProperty = (param) =>
  property = {}
  property.type = 'number' if _.includes param.type.names, 'Number'
  property.description = param.description

  property


doIt()
