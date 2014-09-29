# json格式
# 用户ID， 该json的创建时间，
# [id, 任务名，任务期限，缺勤期限，连续缺勤期限，是否失败，完成天数，缺勤天数，连续缺勤天数， 是否公开]
json.key_format! camelize: :lower

json.user_id @missions[0].user_id
json.created_at Time.now

# 输出已完成任务分页数。注意是分页数而不是总数！如果是public_finished_missions，则只显示公开任务的数目
json.page_num @missions_num
json.finished_missions @missions do |mission|
  json.id mission.id
  json.name mission.name
  json.days mission.days
  json.missed_limit mission.missed_limit
  json.drop_out_limit mission.drop_out_limit

  json.aborted mission.aborted
  json.finished_days mission.finished_days
  json.missed_days mission.missed_days
  json.drop_out_days mission.drop_out_days
  json.public mission.public
end
