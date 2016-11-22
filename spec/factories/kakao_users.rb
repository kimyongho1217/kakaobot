FactoryGirl.define do
  factory :kakao_user do
    user_key "fake_user_key"
    active true
    age 35
    sex "male"
    height 180
    weight 80
    recommended_calories 1000
  end
end
