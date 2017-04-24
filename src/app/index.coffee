kmodel = require('k-model')
util = require('k-model/lib/util')
app = module.exports = require('k-client').createApp('example', __filename)
app.serverUse(module, 'k-stylus')
app.loadViews(__dirname + '/../../views')
app.loadStyles(__dirname + '/../../styles')

app.component(require('k-connection-alert'))
app.component(require('k-before-unload'))

# error catching, otherwise the app may crash if an uncaught error is thrown
app.on 'model', (model) ->
	model.on 'error', (err) ->
		console.error err

require './components/home'
require './components/card'
require './routes/home'
