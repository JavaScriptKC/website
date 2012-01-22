#!/usr/bin/env node

express = require 'express'
app = express.createServer()
port = process.env.PORT || 3000
view = require './src/view'
 
app.configure 'production', () ->
	app.use(express.logger({format: ':method :url'}))
	app.use(express.static(__dirname + 'src/public'))	
   app.use(stylus.middleware({src: __dirname + 'src/public' }))

app.set 'views', __dirname + '/src/views'
app.set 'view engine', 'jade'

app.get '/', null,  view.plug

app.listen port

console.log 'server listening on port #{port}'
