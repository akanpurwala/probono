class BuildingUser < ActiveRecord::Base
  belongs_to :building
  belongs_to :user
end
