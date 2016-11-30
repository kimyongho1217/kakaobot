FactoryGirl.define do
  factory :food, aliases: [:hamburger] do
    sequence(:name) { |n| "햄버거#{n}" } 
    weight 100
    calorie 294
    description "햄버거"
  end

  factory :pizza, class: Food do
    sequence(:name) { |n| "피자#{n}" } 
    weight 100
    calorie 266
    description "피자"
  end
end
