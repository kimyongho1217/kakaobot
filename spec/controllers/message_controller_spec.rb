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
