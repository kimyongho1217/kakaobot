require 'rails_helper'

RSpec.describe KakaoUser, type: :model do
  let(:kakao_user) { create(:kakao_user) }
  let(:new_kakao_user) { build(:kakao_user) }
  let(:meal) { create(:meal) }
  let(:meal_food) { build(:meal_food_without_meal) }

  it "has valid factory" do
    expect(kakao_user).to be_valid
  end

  context "with daily_calorie_consumption" do
    it "is 0 when one of age, height or weight is missed" do
      kakao_user.age = 0
      kakao_user.save
      expect(kakao_user.recommended_calories).to eq(0)
    end
    it "is automatically calculated when age is changed" do
      kakao_user.age = 36
      kakao_user.save
      expect(kakao_user.recommended_calories).to eq(1750)
    end
    it "is automatically calculated when height is changed" do
      kakao_user.height = 181
      kakao_user.save
      expect(kakao_user.recommended_calories).to eq(1761)
    end
    it "is automatically calculated when weight is changed" do
      kakao_user.weight = 81
      kakao_user.save
      expect(kakao_user.recommended_calories).to eq(1765)
    end
    it "shows remaining calories to recommended" do
      meal.meal_foods << meal_food
      kakao_user.meals << meal
      expect(kakao_user.calories_remaining).to eq(-639)
    end

    it "shows calories consumed today" do
      meal.meal_foods << meal_food
      kakao_user.meals << meal
      expect(kakao_user.calories_consumed).to eq(2394)
    end

    it "shows 0 if kakao_user don't have any meals today" do
      meal.meal_foods << meal_food
      meal.created_at = 1.days.ago
      kakao_user.meals << meal
      expect(kakao_user.calories_consumed).to eq(0)
    end
  end

  context "with session_id" do
    it "generates session_id when it's created" do
      expect(kakao_user.session_id).to be_truthy
    end

    it "keeps session_id when it's manully generated" do
      new_kakao_user.regenerate_session_id
      session_id = new_kakao_user.session_id
      new_kakao_user.save
      expect(new_kakao_user.session_id).to eq(session_id)
    end
  end
end
