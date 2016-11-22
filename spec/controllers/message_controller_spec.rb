require 'rails_helper'

RSpec.describe MessageController, type: :controller do
  let(:user_key) { Faker::Crypto.md5 }
  describe "#create" do
    it "returns correct json" do
      post :create, user_key: :user_key, type: "text", content: "테스트"
      json_body = JSON.parse(response.body)
      expect(json_body["message"]["text"]).to eq("챗봇앱이 준비중입니다")
    end
  end
end
