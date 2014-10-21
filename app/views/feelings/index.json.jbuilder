json.array!(@feelings) do |feeling|
  json.id feeling.id
  json.missionId feeling.mission_id
  json.createdAt feeling.created_at
  json.updatedAt feeling.updated_at
  json.content feeling.content
  json.dayName feeling.day_name
end
