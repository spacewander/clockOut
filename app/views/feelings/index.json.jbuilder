json.array!(@feelings) do |feeling|
  json.extract! feeling, :id
  json.url feeling_url(feeling, format: :json)
end
