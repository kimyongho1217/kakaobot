class Meal < ActiveRecord::Base
  belongs_to :kakao_user
  has_many :meal_foods
end
