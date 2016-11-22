class Meal < ActiveRecord::Base
  belongs_to :kakao_user
  has_many :meal_foods

  before_save do |meal|
    meal.total_calorie_consumption = meal_foods.sum(:calorie_consumption)
  end
  
end
