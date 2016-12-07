class KakaoUser < ActiveRecord::Base
  has_many :meals
  has_many :meals_today, -> { where("created_at >= ?", Time.now.beginning_of_day()) }, class_name: 'Meal'

  before_save :calculate_recommended_calories!
  has_secure_token :session_id

  def calories_remaining
    recommended_calories - calories_consumed
  end

  def calories_consumed
    meals_today.sum(:total_calorie_consumption)
  end

  private
  def calculate_recommended_calories!
    return if !age_changed? and !sex_changed? and !height_changed? and !weight_changed?
    if [age, height, weight].any? { |item| item.nil? or item <= 0 } or sex.blank?
      recommended_calories = 0
    else
      if sex == "male"
        recommended_calories = (weight * 10) + (height * 6.25) - (age * 5) + 5 
      else
        recommended_calories = (weight * 10) + (height * 6.25) - (age * 5) - 161
      end
    end
    self.recommended_calories = recommended_calories
  end
end
