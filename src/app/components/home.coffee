linkify = require('linkify-it')()
require 'whatwg-fetch'
app = require '../index'

class Home

	create: ->
		@model.on 'change', 'text', @changed
		@input.focus()

	changed: =>
		clearTimeout(@timer) if @timer
		@timer = setTimeout @getpreview, 1000

	setresult: (ex, json) =>
		if ex or json.error
			@model.set('error', ex or json.error)
			@model.del('card')
			@model.del('json')
		else
			@model.set('card', json)
			@model.set('json', json)

	getpreview: =>
		self = @
		text = @model.get('text')
		return if typeof text is 'undefined'

		@model.del('error')
		matches = linkify.match(text) or []
		urls = (m?.url for m in matches)

		if urls?.length is 1
			url = urls[0]
			console.log "getting #{url}"
			@model.set 'card', 'fetch'
			window.fetch("/api?url=#{encodeURIComponent(url)}")
				.then((response) -> response.json())
				.then((json) -> self.setresult null, json)
				.catch((ex) -> self.setresult ex, json)



app.component 'home', Home
