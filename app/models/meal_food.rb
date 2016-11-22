class MealFood < ActiveRecord::Base
  belongs_to :meal
  belongs_to :food
  belongs_to :food_unit

  before_save :update_calorie_consumption!
  after_save do |meal_food|
    meal_food.meal.save! if calorie_consumption_changed? #to update total_calorie_consumption of meal
  end

  private
  def update_calorie_consumption!
    self.calorie_consumption = count * food_unit.weight_per_unit * food.calorie / food.weight
  end
end
