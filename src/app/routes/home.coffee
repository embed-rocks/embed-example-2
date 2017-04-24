app = require '../index'

app.get '/', (page, model, params, next) ->
	page.render 'home'


