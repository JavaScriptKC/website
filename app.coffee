#!/usr/bin/env node

express = require 'express'
app = express.createServer()
port = process.env.PORT || 3000
path = require 'path'
stylus = require 'stylus'

app.configure 'development', () ->
  app.use(express.logger({format: ':method :url'}))
  app.use(express.static(path.join(__dirname, 'public'))) 
  app.use(stylus.middleware({src: path.join(__dirname, 'public')}))

app.configure 'production', () ->
  app.use(express.logger({format: ':method :url'}))
  app.use(express.static(path.join(__dirname, 'public'))) 
  app.use(stylus.middleware({src: path.join(__dirname, 'public'), compress: true  }))

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.get '/', (req, res) ->
  res.render 'plug', res.data

app.listen port

console.log 'server listening on port #{port}'
