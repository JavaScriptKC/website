#!/usr/bin/env node

express = require 'express'
app = express.createServer()
port = process.env.PORT || 3000

app.configure 'production', () ->
	app.use(express.logger({format: ':method :url'}))
	app.use(express.static(__dirname + 'src/public'))	

app.set 'views', __dirname + '/src/views'
app.set 'view engine', 'jade'

app.listen port

console.log 'server listening on port #{port}'
