app = require '../index'

class Card

	create: -> window.iFrameResize({ checkOrigin: false })

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
		
	preferOembedInIframe: ->
		item = @model.get 'item'
		item?.oembed?.type is 'rich' and item?.url.match(/facebook\.com|twitter\.com/i)

	preferOembedStraight: ->
		item = @model.get 'item'
		item?.oembed?.type is 'rich' and item?.url.match(/airtable\.com|mathembed\.com|soundcloud\.com/i)

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

app.component 'card', Card
