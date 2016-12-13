require 'rails_helper'

RSpec.describe MessageController, type: :controller do
  let(:user_key) { Faker::Crypto.md5 }
  let(:kakao_user) { create(:kakao_user) }

  describe "#create" do
    context "with wit.ai" do
      it "ask food information when it is missed" do
      end

      it "ask unit information when it is missed" do
      end

      it "says calories consumed when all information is accessiable" do
      end

      it "create meal when user says eat something" do
      end

      it "create meal_food when user says eat something" do
      end
    end

    context "fixed response" do
      it "returns expected value when user asks 도움말" do
        post :create, user_key: kakao_user.user_key, type: "text", content: "도움말"
        json_body = JSON.parse(response.body)
        expect(json_body["message"]["text"]).to eq("아래와 같이 적어보세요\"아메리카노\"\"고구마 1개, 바나나 1개\"\"오늘 얼마나 먹었지?\"\"남은 칼로리\"")
      end

      it "returns expected value when user asks 먹은 음식 적기" do
        post :create, user_key: kakao_user.user_key, type: "text", content: "먹은 음식 적기"
        json_body = JSON.parse(response.body)
        expect(json_body["message"]["text"]).to eq("안녕하세요. 식사 잘 하셨나요? ^^아래와 같이 적어주세요.\"고구마 1개, 바나나 1개\"\"아메리카노\"")
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
