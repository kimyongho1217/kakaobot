FactoryGirl.define do
  factory :kakao_user do
    user_key "fake_user_key"
    active true
    age 35
    sex "male"
    height 180
    weight 80
    recommended_calories 1000
    active_type :normal
  end

  factory :kakao_user_without_info, class: KakaoUser  do
    user_key "fake_user_key1"
    active true
  end
end
