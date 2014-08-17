class User < ActiveRecord::Base
  has_many :missions, :dependent => :destroy
  has_many :supervisions
  has_many :missions, through: :supervisions
  has_many :participantions
  has_and_belongs_to_many :groups
end
