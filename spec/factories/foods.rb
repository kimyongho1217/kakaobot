FactoryGirl.define do
  factory :food, aliases: [:hamburger] do
    name "햄버거"
    weight 100
    calorie 294.9
    description "햄버거"
  end

  factory :pizza, class: Food do
    name "피자"
    weight 100
    calorie 266
    description "피자"
  end
end
