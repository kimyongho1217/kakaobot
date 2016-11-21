FactoryGirl.define do
  factory :food, aliases: [:hamburger] do
    name "햄버거"
    unit_calorie 294.9
    description "햄버거"
  end

  factory :pizza, class: Food do
    name "피자"
    unit_calorie 266
    description "피자"
  end
end
