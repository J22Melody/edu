# require
express = require 'express'
json2xml = require 'json2xml'
forEach= (require 'async-foreach').forEach

remote = require './remote'
db = (require './db').db

# config
app = express()

app.use((require 'body-parser')())

# common request handle
app.get '/', (req, res) ->
  sum = 0
  forEach [1,2,3], (item, index, arr) ->
    done = @async()
    setTimeout ->
      sum += item
      done()
    , 1000
  , (notAborted, arr) ->
    res.send "#{sum}"

# api request handle
app.get '/courses/:desSysId', (req, res) ->
  desSysId = req.params.desSysId
  stuId = req.query.stuId
  srcSysId = req.query.srcSysId
  remote.course.search desSysId, {}, (data) ->
    if stuId and srcSysId
      forEach data, (course, index, arr) ->
        done = @async()
        db.selected {srcSysId: srcSysId, stuId:stuId, desSysId:desSysId, courseId: course.id}, (result) ->
            course.selected = result
            done()
      , (notAborted, arr) ->
        # todo 这个json2xml parser真是坑
        res.send json2xml([{'course': course}] for course in data)
    else
      res.send json2xml([{'course': course}] for course in data)

app.post '/select', (req, res) ->
  db.select req.body, (result) ->
    res.send success: result

app.post '/unselect', (req, res) ->
  db.unselect req.body, (result) ->
    res.send success: result

# start server
server = app.listen 3002, ->
  console.log 'Listening on port %d', server.address().port
