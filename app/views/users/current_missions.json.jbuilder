# json格式
# 用户ID， 该json的创建时间，
# [id， 任务名，任务期限，缺勤期限，连续缺勤期限，完成天数，缺勤天数，连续缺勤天数， 内容， 是否公开，是否受监督]
json.key_format! camelize: :lower

json.user_id @missions[0].user_id
json.created_at Time.now

json.current_missions @missions do |mission|
  json.id mission.id
  json.name mission.name
  json.days mission.days
  json.missed_limit mission.missed_limit
  json.drop_out_limit mission.drop_out_limit

  json.finished_days mission.finished_days
  json.missed_days mission.missed_days
  json.drop_out_days mission.drop_out_days
  json.content mission.content

  json.aborted mission.aborted
  json.finished mission.finished
  json.public mission.public
  json.supervised mission.supervised
  # 添加can_clock_out属性。由服务器端计算完是否需要打卡
  json.can_clock_out mission.can_clock_out
end
