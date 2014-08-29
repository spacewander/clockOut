require 'digest/sha2'

# 用户类
class User < ActiveRecord::Base
  has_many :missions, :dependent => :destroy
  has_many :supervisions
  has_many :missions, through: :supervisions
  has_many :participantions
  has_and_belongs_to_many :groups

  validates :name, :email, :password, presence: true
  validates :name, :email, uniqueness: true
  validates :name, length: { maximum: 30,
    too_long: "用户名长度不能超过%{count}个字符" }
  # 注，在保存用户名之前去掉两端的空白

  validates :password, :confirmation => true
  attr_reader :password
  attr_accessor :password_confirmation
  @global_hash = 'clockOut'

  validates :email, format: { with: /\A\w+@\w+(?:\.[a-zA-Z]+)+\z/ }
  validates :year, numericality: { only_integer: true, 
    greater_than: 1900, message: "出生年份不能早于1900",
    less_than_or_equal_to: 2014, message: "出生年份过晚"}, 
    if: Proc.new {|user| user.year}
  validates :date, format: { with: /\A\d\d-\d\d\z/ } ,
    if: Proc.new {|user| user.date}
  validates :member_no, uniqueness: true
  validates :member_no, numericality: { only_integer: true, greater_than: 0 }

  validate :date_cannot_be_invalid

  # 验证日期是否是合法的
  def date_cannot_be_invalid
    return unless date

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

  def self.authenticate(name, password)
    if user = find_by_name(name)
      if user.password_hash == encrypt_password(password, user.salt)
        user
      end
    end
  end

  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.password_hash = self.class.encrypt_password(password, salt)
    end
  end

  # 标记浏览某个用户的主页的人是否是该用户，如果不是，那么就是visitor
  def is_visitor=(is_visitor)
    @is_visitor = is_visitor
  end

  private

  def password_given
    errors.add(:password, "请输入密码") unless password_hash.present?
  end

  def self.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + @global_hash + salt)[0, 32]
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand(36 ** 4).to_s(36)
  end

end
