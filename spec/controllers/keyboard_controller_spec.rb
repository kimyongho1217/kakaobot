require 'rails_helper'

RSpec.describe KeyboardController, type: :controller do
  describe "#show" do
    it "returns correct json" do
      get :show
      json_body = JSON.parse(response.body)
      expect(json_body["type"]).to eq("buttons")
      expect(json_body["buttons"]).to match_array(["남은 칼로리 보기", "도움말", "먹은 음식 적기"])
    end
  end
end
