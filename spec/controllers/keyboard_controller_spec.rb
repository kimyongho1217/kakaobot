require 'rails_helper'

RSpec.describe KeyboardController, type: :controller do
  describe "#show" do
    it "returns correct json" do
      get :show
      json_body = JSON.parse(response.body)
      expect(json_body["type"]).to eq("buttons")
      expect(json_body["buttons"]).to match_array(["칼로리를 알려줘"])
    end
  end
end
