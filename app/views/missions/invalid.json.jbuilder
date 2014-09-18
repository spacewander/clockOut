json.err '不能通过验证'
json.detail @mission.errors.keys do |name|
  json.set! name, @mission.errors[name]
end
