FactoryGirl.define do
  factory :food_unit, aliases: [:hamburger_unit] do
    name "개"
    weight_per_unit 200
    association :food, factory: :hamburger
  end

  factory :pizza_unit_1, class: FoodUnit do
    name "판"
    weight_per_unit 900
    association :food, factory: :pizza
  end

  factory :pizza_unit_2, class: FoodUnit do
    name "조각"
    weight_per_unit 150
    association :food, factory: :pizza
  end
end
