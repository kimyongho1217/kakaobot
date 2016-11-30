class Food < ActiveRecord::Base
  include WitClient
  has_many :food_units

end
