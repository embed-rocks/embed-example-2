app = require '../index'

COMBINED_MAX_LENGTH_FOR_SMALL_CARD = 180

oembedSites = [
	'facebook.com',
	'twitter.com',
	'airtable.com',
	'mathembed.com',
	'soundcloud.com'
]

trim = (description, len) ->
	if description.length > len
		description = description.substring(0, len)
		description = description.substring(0, description.lastIndexOf(' ')) + '...'

	description = description.trim()
	description

class Card

	html5Video: ->
		item = @model.get 'item'
		item?.type is 'video' and item?.videos?[0]?.type?.substring(0, 5) is 'video' and item?.videos?[0]?.type isnt 'video/flash'

	iframeVideo: ->
		item = @model.get 'item'
		item?.videos?[0] and (item.videos[0].type is 'video/flash' or item.videos[0].type?.substring(0, 5) isnt 'video')

	play: ->
		@model.set 'play', true
		document.addEventListener 'keydown', @keydown, true
		
	stop: ->
		@model.del 'play'

	publishedDate: (date) ->
		if date?.parsed
			d = Date.parse(date.parsed)
			if d
				return new Date(d).toLocaleString()

		''
		
	preferOembed: ->
		toRegExp = (arr) -> new RegExp("^https?:\/\/(?:www\.)?" + arr.map((el) -> "(?:#{el})"  ).join('|') + "$", 'i')

		return false if @model.get('small')

		item = @model.get 'item'
		#item?.oembed?.type is 'rich' and item?.url.match(/^https?:\/\/(?:www\.)?(?:airtable\.com|mathembed\.com|soundcloud\.com)/i)
		item?.oembed?.type is 'rich' and item?.url.match(toRegExp(oembedSites))

	showArticle: (ms) ->
		clearTimeout @timer
		set = => @model.set 'showArticle', true
		@timer = setTimeout set, ms
		
	hideArticle: (ms) ->
		clearTimeout @timer
		hide = => @model.del 'showArticle'
		@timer = setTimeout hide, ms
		
	videoSize: ->
		item = @model.get 'item'
		if item?.videos?[0]
			v = item?.videos?[0]
			size = @calculateOptimalDimensions v.width, v.height, v.fixedHeight
			"width: #{size.w}; height: #{size.h}"
		else
			""

	hasText: ->
		item = @model.get 'item'
		item?.title and item?.description

	descriptionForSmallCard: (item) ->

		if item
			l = item.title?.length + item.description?.length - COMBINED_MAX_LENGTH_FOR_SMALL_CARD
			if l > 0
			  description = trim(item.description, item.description.length - l)

			description or item.description
		else
			''

	keydown: (e) =>
		key = e.keyCode or e.which
		if key is 27
			e.stopPropagation()
			document.removeEventListener 'keydown', @keydown, true
			@stop()

	# expand (video) size to the maxwidth/maxheight
	# some sites want to have a fixed height video/swf, so take that into account
	calculateOptimalDimensions: (width, height, isFixedHeightVideo) ->
		w = ''
		h = ''

		if width and height
			ratio = width / height
			w = '90vw'
			h = if isFixedHeightVideo then height +'px' else "#{90 / ratio}vw"
		{ w, h }

	dimensions: (image) ->
		small = @model.get 'small'

		if small
			h = 125
			w = 125 * (image.width / image.height)
		else
			w = 750
			h = (750 * image.height) / image.width

		"width: #{w}px; height: #{h}px"

app.component 'card', Card
