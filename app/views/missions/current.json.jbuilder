# 跟users/current_missions.json差不多
json.key_format! camelize: :lower

json.created_at Time.now
json.id @mission.id
json.name @mission.name
json.days @mission.days
json.missed_limit @mission.missed_limit
json.drop_out_limit @mission.drop_out_limit

json.finished_days @mission.finished_days
json.missed_days @mission.missed_days
json.drop_out_days @mission.drop_out_days
json.content @mission.content

json.aborted @mission.aborted
json.finished @mission.finished
json.public @mission.public
json.supervised @mission.supervised
