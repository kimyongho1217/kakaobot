require 'rails_helper'

RSpec.describe KakaoUser, type: :model do
  let(:kakao_user) { create(:kakao_user) }

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
      expect(kakao_user.recommended_calories).to eq(100)
    end
    it "is automatically calculated when height is changed" do
      kakao_user.height = 181
      kakao_user.save
      expect(kakao_user.recommended_calories).to eq(100)
    end
    it "is automatically calculated when weight is changed" do
      kakao_user.weight = 81
      kakao_user.save
      expect(kakao_user.recommended_calories).to eq(100)
    end
    it "shows remaining calories to recommended" do
    end
  end
end
