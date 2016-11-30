class FoodUnit < ActiveRecord::Base
  include WitClient
  belongs_to :food

end
