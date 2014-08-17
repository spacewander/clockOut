class Mission < ActiveRecord::Base
  belongs_to :user
  has_many :supervisions
  has_many :user, through: :supervisions
  has_many :feelings
end

