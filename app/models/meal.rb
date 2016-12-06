class Meal < ActiveRecord::Base
  belongs_to :kakao_user
  has_many :meal_foods

  before_create :set_ate_at_now

  def set_ate_at_now
    self.ate_at = Time.now if ate_at.nil?
  end

  before_save do |meal|
    meal.total_calorie_consumption = meal_foods.sum(:calorie_consumption)
  end
  
end
