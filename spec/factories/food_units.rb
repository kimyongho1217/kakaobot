FactoryGirl.define do
  factory :food_unit, aliases: [:hamburger_unit] do
    name "개"
    weight_per_unit 200
    hamburger
  end

  factory :pizza_unit_1, class: FoodUnit do
    name "판"
    weight_per_unit 900
    pizza
  end

  factory :pizza_unit_2, class: FoodUnit do
    name "조각"
    weight_per_unit 150
    pizza
  end
end
