ActiveAdmin.register FoodUnit do
  permit_params :name, :weight_per_unit, :synonyms_raw, :food_id
  form do |f|
    f.inputs "Food" do
      f.input :food, member_label: :name
    end
    f.inputs "Unit Details" do
      f.input :name
      f.input :weight_per_unit
      f.input :synonyms_raw, as: :text
    end
    f.actions
  end

end
