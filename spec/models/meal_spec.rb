require 'rails_helper'

RSpec.describe Meal, type: :model do
  let(:meal) { create(:meal) }
  let(:meal_food) { build(:meal_food_without_meal) }

  context "with calorie_consumption" do
    it "automatially calculated with meal_food is added" do
      expect(meal.total_calorie_consumption).to eq(0)
      meal.meal_foods << meal_food
      meal.save
      expect(meal.total_calorie_consumption).to eq(2394)
    end
    it "automatially calculated with existing meal_food is updated" do
      meal.meal_foods << meal_food
      meal.save
      expect(meal.total_calorie_consumption).to eq(2394)
      meal_food.count = 2
      meal_food.save
      expect(meal.total_calorie_consumption).to eq(4788)
    end
  end

  context "with ate_at" do
    it "is set as now when it's created" do
      expect(meal.ate_at).to be > 1.minutes.ago
    end

    it "is set as passed when it's created" do
      another_meal = build(:meal)
      another_meal.ate_at = 1.days.ago
      another_meal.save
      another_meal.reload
      expect(another_meal.ate_at).to be <= 1.days.ago
    end
  end
end
