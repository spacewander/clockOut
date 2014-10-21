# 用户可以在每日打卡中添加心得
# 一个心得包括对应的内容，以及创建的序号（第N天）
# 同一项打卡在一天中只可创建一个心得，但是可以修改任意次
# 不能修改当天之前的心得
class Feeling < ActiveRecord::Base
  belongs_to :mission

  validates :mission_id, :presence => { message: '不能为空！' }
  validates :mission_id, numericality: { only_integer: true, greater_than: 0, 
                                         message: '所给的任务id不正确'}
end

