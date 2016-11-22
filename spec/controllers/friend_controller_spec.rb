require 'rails_helper'

RSpec.describe FriendController, type: :controller do

  let(:user_key) { Faker::Crypto.md5 }
  let(:kakao_user) { KakaoUser.create(user_key: Faker::Crypto.md5) }

  describe "#create" do
    it "creates new kakao user" do
      post :create, user_key: :user_key
      expect(KakaoUser.exists?(user_key: :user_key)).to be_truthy
    end

    it "activates existing kakao_user" do
      kakao_user.active = false
      kakao_user.save
      post :create, user_key: kakao_user.user_key
      kakao_user.reload
      expect(kakao_user.active).to be_truthy
    end

    it "returns correct json" do
      post :create, user_key: :user_key
      json_body = JSON.parse(response.body)
      expect(json_body["message"]).to eq("SUCCESS")
      expect(json_body["comment"]).to eq("정상 응답")
    end
  end

  describe "#destroy" do
    it "deactivate kakao_user" do
      delete :destroy , user_key: kakao_user.user_key
      kakao_user.reload
      expect(kakao_user.active).to be_falsy
    end

    it "returns correct json" do
      delete :destroy , user_key: :user_key
      json_body = JSON.parse(response.body)
      expect(json_body["message"]).to eq("SUCCESS")
      expect(json_body["comment"]).to eq("정상 응답")
    end
  end
end
