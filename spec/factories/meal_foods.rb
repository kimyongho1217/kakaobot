FactoryGirl.define do
  factory :meal_food do
    meal
    association :food, factory: :hamburger
    association :food_unit, factory: :hamburger_unit
    count 1 
  end

  factory :meal_food_without_meal, class: MealFood do
    association :food, factory: :pizza
    association :food_unit, factory: :pizza_unit_1
    count 1 
  end
end
