class Group < ActiveRecord::Base
  has_many :activities
  has_and_belongs_to_many :users
end
