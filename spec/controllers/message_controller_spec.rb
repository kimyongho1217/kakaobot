require 'rails_helper'

RSpec.describe MessageController, type: :controller do
  let(:user_key) { Faker::Crypto.md5 }
  let(:kakao_user) { create(:kakao_user) }
  let(:ramen) { create(:ramen) }
  let(:seafood) { create(:seafood) }
  let(:seafood_ramen) { create(:seafood_ramen) }
  let(:banana) { create(:banana) }

  #json fixtures
  let(:single_food_response) { JSON.parse(File.read("spec/fixtures/single_food.json")) }
  let(:ambiguous_unit_response) { JSON.parse(File.read("spec/fixtures/ambiguous_unit.json")) }
  let(:two_foods_response) { JSON.parse(File.read("spec/fixtures/two_foods.json")) }
  let(:get_calories_response) { JSON.parse(File.read("spec/fixtures/get_calories.json")) }
  let(:unit_without_food_response) { JSON.parse(File.read("spec/fixtures/unit_without_food.json")) }
  let(:food_only_response) { JSON.parse(File.read("spec/fixtures/food_only.json")) }
  let(:food_again_response) { JSON.parse(File.read("spec/fixtures/food_again.json")) }
  let(:two_foods_only_response) { JSON.parse(File.read("spec/fixtures/two_foods_only.json")) }


  describe "#create" do

    context "eatFood" do
      before :each do
        controller.instance_variable_set(:@kakao_user, kakao_user)
      end

      it "returns expected output when response from wit have 1 food information" do
        ramen
        expect(controller.eat_food(single_food_response)).to include({
          "foodConsumed" => "라면 1개",
          "caloriesConsumed" => 266,
          "caloriesRemaining" => 2463
        })
      end

      it "returns expected output when response from wit have 2 food information" do
        ramen and banana
        expect(controller.eat_food(two_foods_response)).to include({
          "foodConsumed" => "라면 532, 바나나 150",
          "multiFood" => true,
          "caloriesConsumed" => 682,
          "caloriesRemaining" => 2047
        })
      end

      it "returns expected output when response from wit have 2 food information but 1 doesn't have calorie information" do
        ramen
        expect(controller.eat_food(two_foods_response)).to include({
          "missingFoodInfo" => "바나나",
          "foodConsumed" => "라면 2개",
          "caloriesConsumed" => 532,
          "caloriesRemaining" => 2197
        })
      end

      it "returns expected output when response from wit have 2 food information but both don't have calorie information" do
        expect(controller.eat_food(two_foods_response)).to include({
          "missingFoodInfo" => "라면, 바나나"
        })
      end

      it "returns expected output when response from wit have ambiguous unit" do
        expect(controller.eat_food(ambiguous_unit_response)).to include({
          "ambiguousUnit" => "약간"
        })
      end

      it "returns expected output when we get unit info after ambiguous unit" do
        ramen
        controller.eat_food(ambiguous_unit_response)
        unit_without_food_response['context'] = controller.instance_variable_get(:@kakao_user).context
        expect(controller.eat_food(unit_without_food_response)).to eq({
          "foodConsumed" => "라면 1개",
          "caloriesConsumed" => 266,
          "caloriesRemaining" => 2463
        })
      end

      it "returns searchFood when food name is in many different foods" do
        ramen and seafood_ramen
        expect(controller.eat_food(two_foods_response)).to include({
          "searchFood" => "라면"
        })
      end

      it "returns expected output when we get food name after search request" do
        banana and ramen and seafood_ramen
        controller.eat_food(two_foods_response)
        food_only_response['context'] = controller.instance_variable_get(:@kakao_user).context
        expect(controller.eat_food(food_only_response)).to include({
          "foodConsumed" => "해물라면 532, 바나나 150",
          "multiFood" => true,
          "caloriesConsumed" => 682,
          "caloriesRemaining" => 2047
        })
      end

      it "returns expected output when we get food name after search request" do
        banana and ramen and seafood_ramen
        controller.eat_food(two_foods_response)
        food_again_response['context'] = controller.instance_variable_get(:@kakao_user).context
        expect(controller.eat_food(food_again_response)).to include({
          "foodConsumed" => "라면 532, 바나나 150",
          "multiFood" => true,
          "caloriesConsumed" => 682,
          "caloriesRemaining" => 2047
        })
      end

      it "merge into one food if merged word is foodname" do
        seafood and ramen and seafood_ramen
        expect(controller.eat_food(two_foods_only_response)).to include({
          "missingNumber" => "해물라면"
        })
        unit_without_food_response['context'] = controller.instance_variable_get(:@kakao_user).context
        expect(controller.eat_food(unit_without_food_response)).to include({
          "foodConsumed" => "해물라면 1개",
          "caloriesConsumed" => 266,
          "caloriesRemaining" => 2463
        })
      end

      it "asks quantity if number is missing" do
        seafood_ramen
        expect(controller.eat_food(food_only_response)).to include({
          "missingNumber" => "해물라면"
        })
      end

      it "returns expected output after asking quantity which is due to missing quantity" do
        seafood_ramen
        controller.eat_food(food_only_response)
        unit_without_food_response['context'] = controller.instance_variable_get(:@kakao_user).context
        expect(controller.eat_food(unit_without_food_response)).to include({
          "foodConsumed" => "해물라면 1개",
          "caloriesConsumed" => 266,
          "caloriesRemaining" => 2463
        })
      end
    end

    context "getCalories" do
      before :each do
        controller.instance_variable_set(:@kakao_user, kakao_user)
      end

      it "returns expected output" do
        expect(controller.get_calories(get_calories_response)).to include({
          "caloriesConsumed" => 0,
          "caloriesRemaining" => 2729
        })
      end
    end

    context "fixed response" do
      it "returns expected value when user asks 먹은 음식 적기" do
        post :create, user_key: kakao_user.user_key, type: "text", content: "먹은 음식 적기"
        json_body = JSON.parse(response.body)
        expect(json_body["message"]["text"]).to eq("안녕하세요. 식사 잘 하셨나요? ^^\n아래 예시와 같이 적어주시면 칼로리가 기록됩니다.\n\"고구마 1개, 바나나 1개\"\n\"아메리카노\"")
      end

      it "returns expected value when user asks 도움말" do
        post :create, user_key: kakao_user.user_key, type: "text", content: "도움말"
        json_body = JSON.parse(response.body)
        expect(json_body["message"]["text"]).to eq("아래와 같이 적어보세요\n\"아메리카노\"\n\"고구마 1개, 바나나 1개\"\n\"오늘 얼마나 먹었지?\"\n\"남은 칼로리\"")
      end
    end

    context "kakao users" do
      it "create kakao user if it doesn't exist" do
        post :create, user_key: :user_key, type: "text", content: "테스트"
        expect(KakaoUser.where(user_key: :user_key).exists?).to be_truthy
      end

      it "activates kakao user if it exists and is not active" do
        kakao_user.active = false
        kakao_user.save
        post :create, user_key: kakao_user.user_key, type: "text", content: "테스트"
        kakao_user.reload
        expect(kakao_user.active).to be_truthy
      end
    end
  end
end
