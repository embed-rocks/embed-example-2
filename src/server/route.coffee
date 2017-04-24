key = "your-api-key"
api =  "https://api.embed.rocks/api/"
request = require 'request'

module.exports = (expressApp) ->
	expressApp.get '/api', (req, res, next) ->
		url = "#{api}?key=#{key}&url=#{req.query.url}"
		console.log "getting #{url}"
		request.get(url).pipe(res)
