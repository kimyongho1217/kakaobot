ActiveAdmin.register FoodUnit do
  active_admin_import timestamps: true,
    #on_duplicate_key_update: { columns: [:name, :weight_per_unit, :synonyms_raw, :food_id] },
    before_batch_import: proc { |import|
      import.csv_lines.uniq! {|line| line.first }
    }

  permit_params :name, :weight_per_unit, :food_id
  form do |f|
    f.inputs "Food" do
      f.input :food, member_label: :name
    end
    f.inputs "Unit Details" do
      f.input :name
      f.input :weight_per_unit
      #f.input :synonyms_raw, as: :text
    end
    f.actions
  end

end
