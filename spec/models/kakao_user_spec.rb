require 'rails_helper'

RSpec.describe KakaoUser, type: :model do
  let(:kakao_user) { create(:kakao_user) }
  let(:new_kakao_user) { build(:kakao_user) }
  let(:kakao_user_without_info) { create(:kakao_user_without_info) }
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
      expect(kakao_user.recommended_calories).to eq(2721)
    end

    it "is automatically calculated when height is changed" do
      kakao_user.height = 181
      kakao_user.save
      expect(kakao_user.recommended_calories).to eq(2738)
    end

    it "is automatically calculated when weight is changed" do
      kakao_user.weight = 81
      kakao_user.save
      expect(kakao_user.recommended_calories).to eq(2744)
    end

    it "is automatically calculated when active_type is changed" do
      kakao_user.active_type = "athlete"
      kakao_user.save
      expect(kakao_user.recommended_calories).to eq(3334)
    end

    it "shows remaining calories to recommended" do
      meal.meal_foods << meal_food
      kakao_user.meals << meal
      expect(kakao_user.calories_remaining).to eq(335)
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

  context "with missing_info" do
    it "returns false if there's any missing information" do
      kakao_user.age = 0
      kakao_user.save
      expect(kakao_user.missing_info?).to be_truthy
    end
    it "returns true if kakao_user has every information required for calories calculation" do
      expect(kakao_user.missing_info?).to be_falsy
    end
  end

  context "with set_info" do
    before :each do
      remove_request_stub(@stub)
    end

    it "correctly updates sex when message is 남자" do
      kakao_user_without_info.set_info "남자"
      expect(kakao_user_without_info.sex).to eq("male")
    end

    it "correctly updates sex when message is 여자" do
      kakao_user_without_info.set_info "여자"
      expect(kakao_user_without_info.sex).to eq("female")
    end

    it "correctly updates age when message is 38" do
      stub_request(:any, /https:\/\/api\.wit\.ai*+/)
      .to_return(
        status: 200,
        body: { "entities":{"number":[{"confidence":1,"type":"value","value":38}]} }.to_json,
        headers: {})
      kakao_user_without_info.sex = "male"
      kakao_user_without_info.set_info "38"
      expect(kakao_user_without_info.age).to eq(38)
    end

    it "correctly updates weight when message is 75" do
      stub_request(:any, /https:\/\/api\.wit\.ai*+/)
      .to_return(
        status: 200,
        body: { "entities":{"number":[{"confidence":1,"type":"value","value":75}]} }.to_json,
        headers: {})
      kakao_user_without_info.sex = "male"
      kakao_user_without_info.age = 35
      kakao_user_without_info.set_info "75"
      expect(kakao_user_without_info.weight).to eq(75)
    end

    it "correctly updates heght when message is 181" do
      stub_request(:any, /https:\/\/api\.wit\.ai*+/)
      .to_return(
        status: 200,
        body: { "entities":{"number":[{"confidence":1,"type":"value","value":181}]} }.to_json,
        headers: {})
      kakao_user_without_info.sex = "male"
      kakao_user_without_info.age = 35
      kakao_user_without_info.weight = 75
      kakao_user_without_info.set_info "181"
      expect(kakao_user_without_info.height).to eq(181)
    end

    it "correctly updates active_type when message is 비할동적" do
      kakao_user_without_info.sex = "male"
      kakao_user_without_info.age = 35
      kakao_user_without_info.weight = 75
      kakao_user_without_info.height = 181
      kakao_user_without_info.set_info "보통활동"
      expect(kakao_user_without_info.active_type).to eq("normal")
    end
  end

  context "with get_response" do
    it "returns expected value when sex is nil" do
      kakao_user.sex = nil
      expect(kakao_user.get_response).to include({
        message: { text: "하루 권장 열량 계산을 위해서 몇 가지만 여쭤볼게요. 성별이 어떻게 되시나요?"},
        keyboard: {
          type: "buttons",
          buttons: [
            "남자",
            "여자"
          ]
        }
      })
    end

    it "returns expected value when age is nil" do
      kakao_user.age = nil
      expect(kakao_user.get_response).to include({
        message: { text: "넵. 초면에 죄송합니다만 나이가 어떻게 되시나요?" }
      })
    end

    it "returns expected value when weight is nil" do
      kakao_user.weight = nil
      expect(kakao_user.get_response).to include({
        message: { text: "현재 체중을 알려주세요." }
      })
    end

    it "returns expected value when height is nil" do
      kakao_user.height = nil
      expect(kakao_user.get_response).to include({
        message: { text: "혹시 키가 어떻게 되시죠?" }
      })
    end

    it "returns expected value when active_type is nil" do
      kakao_user.active_type = nil
      expect(kakao_user.get_response).to include({
        message: { text: "평소 운동을 얼마나 하시나요?"},
        keyboard: {
          type: "buttons",
          buttons: [
            "비활동적(운동 거의 안 함)",
            "가벼운활동(가벼운 운동 - 주1~3회)",
            "보통활동(보통 - 주3~5회)",
            "적극적활동(적극적으로 운동함 - 매일)",
            "운동선수수준"
          ]
        }
      })
    end

    it "returns expected value when just filled informations required" do
      return_json = {
        message:
          { text: "알려주셔서 감사합니다. 고객님의 하루 권장 열량은 #{kakao_user.recommended_calories}kcal 입니다.\n"\
            "이제 먹은 음식을 아래와 같이 적어주시면 제가 칼로리를 알려드려요.\n"\
            "\"고구마 1개, 바나나 1개\"\n"\
            "\"고구마 한 개랑 바나나 한 개 먹었어\"\n"\
            "이외에도 제 도움이 필요하면 언제든지 \"도움말\"이라고 적어주세요." }
      }
      expect(kakao_user.get_response).to include(return_json)
    end
  end
end
