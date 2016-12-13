ActiveAdmin.register Food do
  active_admin_import timestamps: true,
    on_duplicate_key_update: { conflict_target: [:name], columns: [:weight, :calorie, :carbohydrate, :protein, :fat, :sugars, :sodium, :cholesterol, :saturated_fat, :trans_fat] },
    before_batch_import: proc { |import|
      import.csv_lines.uniq! {|line| line.first }
    }

  permit_params :name, :synonyms_raw, :weight, :calorie, :carbohydrate, :protein, :fat, :sugars, :sodium, :cholesterol, :saturated_fat, :image

  index do
    selectable_column
    id_column
    column :name
    column :weight
    column :calorie
    column :created_at
    column :updated_at
    column :image do |currency|
      image_tag currency.image.url(:thumb)
    end
    actions
  end

  form do |f|
    f.inputs "Food Details" do
      f.input :name
      f.input :synonyms_raw, as: :text
      f.input :weight
      f.input :calorie
      f.input :carbohydrate
      f.input :protein
      f.input :fat
      f.input :sugars
      f.input :sodium
      f.input :cholesterol
      f.input :saturated_fat
      f.input :image, :as => :file, :hint => image_tag(f.object.image.url(:medium))
    end
    f.actions
  end


  show do
    attributes_table do
      row :name
      row :synonyms_raw, as: :text
      row :weight
      row :calorie
      row :carbohydrate
      row :protein
      row :fat
      row :sugars
      row :sodium
      row :cholesterol
      row :saturated_fat
      row 'Units' do
        columns do
          column do
           b "Name"
          end
          column do
            b "Weight Per Unit"
          end
          column do
            b "Synonyms"
          end
        end
        food.food_units.each do |food_unit|
          columns do
            column do
              food_unit.name
            end
            column do
              food_unit.weight_per_unit
            end
            column do
              food_unit.synonyms_raw
            end
          end
        end
      end
    end
  end
end
