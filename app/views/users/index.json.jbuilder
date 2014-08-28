json.array!(@users) do |user|
  json.extract! user, :id, :id, :name, :sex, :year, :date, :password_hash, :salt, :join_date, :email, :last_actived, :member_no
  json.url user_url(user, format: :json)
end
