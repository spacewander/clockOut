class Activity < ActiveRecord::Base
  belongs_to :group
  has_many :participantions
  has_many :users, through: :participantions
  has_many :comments
end
