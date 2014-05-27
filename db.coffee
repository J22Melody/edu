mongoose = require 'mongoose'

Schema = mongoose.Schema
mongoose.connect 'mongodb://localhost'

selectRecordSchema = new Schema
  srcSysId: { type: String, required: true }
  desSysId: { type: String, required: true }
  stuId: { type: String, required: true }
  courseId: { type: String, required: true }

# selectRecordSchema.index { srcSysId: 1, desSysId: 1,stuId: 1,courseId: 1 }, { unique: true }

SelectRecord = mongoose.model('SelectRecord', selectRecordSchema);

exports.db =
  selected: (param, callback) ->
    SelectRecord.findOne param, (err, doc) ->
      callback !!doc

  select: (param, callback) ->
    # 判断是否已经存在 todo 从schema的角度进行multible key验证
    SelectRecord.findOne param, (err, doc) ->
      if doc
        callback false
      else
        record = new SelectRecord param
        record.save (err) ->
          callback !err

  unselect: (param, callback) ->
    SelectRecord.remove param, (err) ->
      callback !err
