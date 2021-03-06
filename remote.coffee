request = require 'request'
xml2json = require 'node-xml2json'

baseUrl =
  'A': 'https://hidden-peak-7319.herokuapp.com'
  'B': 'http://shrouded-forest-5848.herokuapp.com'
  'C': 'http://vps.jiangzifan.com:3005'

apiUrl =
  'A':
    'courseSearch': '/course/search.xml'
  'B':
    'courseSearch': '/course.xml'
  'C':
    'courseSearch': '/classes.xml'

handleData =
  'A': (data) ->
    jsonData = xml2json.parser data
    [{
      'id': course.course_no
      'title': course.title
      'teacher': course.teacher
      'place': course.place
      'credit': course.credit
      'period': course.period
    } for course in jsonData.courses.course][0]
  'B': (data) ->
    jsonData = xml2json.parser data
    [{
      'id': course.id
      'title': course.title
      'teacher': course.instructor
      'place': course.classroom
      'credit': course.credit
      'period': course.class_period
    } for course in jsonData.courses.course][0]
  'C': (data) ->
    jsonData = xml2json.parser data
    courses = jsonData.courses.course
    ({
      'id': course._id
      'title': course.name
      'teacher': course.mentor
      'place': course.place
      'credit': course.credit
      'period': course.period
    }for course in courses)


exports.course = {
  search: (desSysId, param, callback) ->
    url = baseUrl[desSysId] + apiUrl[desSysId]['courseSearch']
    request {url: url, qs: param}, (error, response, body) ->
      callback handleData[desSysId](body)
}
