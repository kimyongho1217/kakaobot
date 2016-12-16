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

  factory :ramen, class: Food do
    name "라면"
    weight 100
    calorie 266
    description "라면"
  end

  factory :seafood_ramen, class: Food do
    name "해물라면"
    weight 100
    calorie 266
    description "해물라면"
  end

  factory :seafood, class: Food do
    name "해물"
    weight 100
    calorie 300
    description "해물"
  end

  factory :banana, class: Food do
    name "바나나"
    weight 100
    calorie 150
    description "바나나"
  end
end
