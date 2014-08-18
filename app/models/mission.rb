class Mission < ActiveRecord::Base
  belongs_to :user
  has_many :supervisions
  has_many :user, through: :supervisions
  has_many :feelings

  validates :name, :days, :missed_days, :missed_limit, :user_id, presence: true
  validates :name, length: { in: 0..100,
    too_long: "打卡项目不能超过100个字符哦"}
  validates :days, :missed_days, :finished_days, :drop_out_days,
    numericality: { only_integer: true, greater_than: 0, less_than: 9999}
  validates :missed_limit, :drop_out_limit,
    numericality: { only_integer: true, greater_than: -1, less_than: 9999}

  validate :special_days_cannot_greater_than_total_days
  validate :limit_cannot_greater_than_toal_days

  def special_days_cannot_greater_than_total_days
    errors.add(:finished_days, '完成日期不能超过总日期') if finished_days > days
    errors.add(:missed_days, '缺勤日期不能超过总日期') if missed_days > days
    if drop_out_days > days
      errors.add(:drop_out_days, '连续缺勤日期不能超过总日期') 
    end
  end

  def limit_cannot_greater_than_toal_days
    errors.add(:missed_limit, '缺勤限制不能超过总日期') if missed_limit > days
    if drop_out_limit > days
      errors.add(:drop_out_limit, '连续缺勤限制不能超过总日期') 
    end
  end

end

