json.key_format! camelize: :lower
json.extract! @feeling, :id, :created_at, :updated_at, 
  :content, :mission_id, :day_name
