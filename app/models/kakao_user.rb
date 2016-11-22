class KakaoUser < ActiveRecord::Base
  has_many :meals
  before_save :calculate_recommended_calories!

  private
  def calculate_recommended_calories!
    return if !age_changed? and !sex_changed? and !height_changed? and !weight_changed?
    if [age, height, weight].any? { |item| item <= 0 }
      self.recommended_calories = 0
    else
      self.recommended_calories = 100
    end
  end
end
