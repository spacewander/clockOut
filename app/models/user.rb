# 用户类
class User < ActiveRecord::Base
  has_many :missions, :dependent => :destroy
  has_many :supervisions
  has_many :missions, through: :supervisions
  has_many :participantions
  has_and_belongs_to_many :groups

  validates :name, :email, :password_hash, presence: true
  validates :name, :email, uniqueness: true
  validates :name, length: { maximum: 30,
    too_long: "用户名长度不能超过%{count}个字符" }
  # 注，在保存用户名之前去掉两端的空白

  validates :email, format: { with: /\A\w+@\w+(?:\.[a-zA-Z]+)+\z/ }
  validates :year, numericality: { only_integer: true, 
    greater_than: 1900, message: "出生年份不能早于%{count}",
    less_than_or_equal_to: 2014, message: "出生年份不能晚于%{count}"}
  validates :date, format: { with: /\A\d\d-\d\d\z/ }
  validates :member_no, uniqueness: true
  validates :member_no, numericality: { only_integer: true, greater_than: 0 }

  validate :date_cannot_be_invalid

  # 验证日期是否是合法的
  def date_cannot_be_invalid
    month, day = date.split('-')
    day = day.to_i()
    case month
      when '01', '03', '05', '07', '08', '10', '12'
      correct = (0 < day) && (day <= 31)
      when '04', '06', '09', '11'
      correct = (0 < day) && (day <= 30)
      when '02'
        if (year % 4) == 0 && (year % 100) != 0
          correct = (0 < day) && (day <= 29)
        else
          correct = (0 < day) && (day <= 28)
        end
      else
        correct = false
    end
    errors.add(:date, '出生日期有问题！') if !correct
  end
end

