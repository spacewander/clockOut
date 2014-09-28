require 'digest/sha2'

# 打卡项目
# 打卡前必填：项目名称，持续天数，中途允许缺勤天数，允许连续缺勤天数
# 选填：描述性内容
# 系统填充：当前完成天数，缺勤天数，连续缺勤天数，是否结束，是否失败
# 打卡项目可以选择是否公开，公开的项目将显示于个人主页
class Mission < ActiveRecord::Base
  belongs_to :user, :inverse_of => :missions, :autosave => true
  has_many :supervisions
  #has_many :user, through: :supervisions
  has_many :feelings

  validates :name, :days, :drop_out_limit, :missed_limit, :user_id, 
    :presence => { message: '不能为空！' }
  validates :name, length: { in: 0..30,
    too_long: "打卡项目不能超过30个字符哦"}

  validates :days, numericality: { only_integer: true, greater_than: 0, 
                                   less_than: 10000, message: '注意日期限制！' }
  validates :missed_days, :finished_days, :drop_out_days,
    numericality: { only_integer: true, greater_than: -1, 
                    less_than: 10000, message: '注意日期限制！' }
  validates :missed_limit, :drop_out_limit,
    numericality: { only_integer: true, greater_than: -1, 
                    less_than: 10000, message: '注意日期限制！' }

  validate :special_days_cannot_greater_than_total_days

  def special_days_cannot_greater_than_total_days
    return unless finished_days && missed_days && drop_out_days && days

    errors.add(:finished_days, '完成日期不能超过总日期') if finished_days > days
    errors.add(:missed_days, '缺勤日期不能超过总日期') if missed_days > days
    if drop_out_days > days
      errors.add(:drop_out_days, '连续缺勤日期不能超过总日期') 
    end
  end

  # 修改任务需要用户认证
  attr_reader :user_token

  def user_token=(user_id)
    @user_token = Mission.encrypt_user_token(user_id)
  end
  
  def self.user_token_correct?(user_id, user_token)
    user_token != "" && user_token == encrypt_user_token(user_id)
  end

  private

  # 加密用户token，用于修改任务时认证用户身份
  def self.encrypt_user_token(user_id)
    begin
      Digest::SHA2.hexdigest(user_id.to_s + ClockOut::Application::GLOBAL_SALT)[0, 16]
    rescue
      # 传入user_id有问题？那么这么处理吧
      ""
    end
  end

end

