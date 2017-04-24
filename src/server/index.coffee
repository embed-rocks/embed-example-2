express = require 'express'
kclient = require 'k-client'
kclient.use(require('k-bundle'))
kmodel = require 'k-model'
racerhighway = require 'k-highway'
coffeeify = require 'coffeeify'
app = require '../app/index'
expressApp = module.exports = express()

publicDir = __dirname + '/../../public'
store = kclient.createBackend()
racerhighwayHandlers = racerhighway store
module.exports.upgrade = racerhighwayHandlers.upgrade

store.on 'bundle', (browserify) ->
  # Add support for directly requiring coffeescript in browserify bundles
  browserify.transform coffeeify

expressApp
  # Serve static files from the public directory
  .use(express.static publicDir)

  # websockets etc.
  .use(racerhighwayHandlers.middleware)

  # Add req.getModel() method
  .use(store.modelMiddleware())

  # Create an express middleware from the app's routes
  .use(app.router())

# setup the server route where we handle the ajax call from the client
# and do the embed.rocks api call
require('./route')(expressApp)

app.writeScripts store, publicDir,
  extensions: [".coffee"]
  sourcemaps: process.env.NODE_ENV isnt 'production'
, (err) ->
  console.log err
  return
