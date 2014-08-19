# 用户可以在每日打卡中添加心得
# 一个心得包括对应的内容，以及创建的序号（第N天）
# 同一项打卡在一天中只可创建一个心得，但是可以修改任意次
# 不能修改当天之前的心得
class Feeling < ActiveRecord::Base
  belongs_to :mission
end

