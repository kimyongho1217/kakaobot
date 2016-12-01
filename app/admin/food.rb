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
    column  :image do |currency|
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



# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
