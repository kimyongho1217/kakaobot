class MealFood < ActiveRecord::Base
  belongs_to :meal
  belongs_to :food
end
