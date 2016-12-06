require 'rails_helper'

RSpec.describe MessageController, type: :controller do
  let(:user_key) { Faker::Crypto.md5 }
  let(:kakao_user) { create(:kakao_user) }

  describe "#create" do
    it "returns correct json" do
      post :create, user_key: :user_key, type: "text", content: "테스트"
      json_body = JSON.parse(response.body)
      expect(json_body["message"]["text"]).to eq("챗봇앱이 준비중입니다")
    end

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
