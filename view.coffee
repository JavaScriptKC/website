require 'feedparser'

module.exports = {
	main: (req, res) -> 
		parser = new FeedParser()

		parser.parseFile('')
		res.render 'home', res.data
}