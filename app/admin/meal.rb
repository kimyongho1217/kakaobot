ActiveAdmin.register Meal do
  index do
    selectable_column
    id_column
    column :total_calorie_consumption
    column :foods do |meal|
      meal.meal_foods.includes(:food).map {|mf| mf.food.name rescue "" }.join(", ")
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :kakao_user
      row :total_calorie_consumption
      row 'Meal Foods' do |n|
        columns do
          column do
           b "Food"
          end
          column do
            b "Count"
          end
          column do
            b "Calorie Consumption"
          end
        end
        meal.meal_foods.includes(:food, :food_unit).each do |meal_food|
          columns do
            column do
              (meal_food.food.name rescue "음식정보가없습니다")
            end
            column do
              "#{meal_food.count}#{meal_food.food_unit.name rescue '개'}"
            end
            column do
              meal_food.calorie_consumption
            end
          end
        end
      end
    end
  end

end
