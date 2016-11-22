require 'rails_helper'

RSpec.describe MealFood, type: :model do
  let(:meal_food) { create(:meal_food) }
  context "with calorie_consumption" do

    it "automatically calculated when it's created" do
      expect(meal_food.calorie_consumption).to eq(588)
    end

    it "automatically calculated when it's updated" do
      meal_food.count = 2
      meal_food.save
      expect(meal_food.calorie_consumption).to eq(1176)
    end
  end
end
