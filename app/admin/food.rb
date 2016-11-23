ActiveAdmin.register Food do
  active_admin_import timestamps: true,
    on_duplicate_key_update: { conflict_target: [:name], columns: [:weight, :calorie, :carbohydrate, :protein, :fat, :sugars, :sodium, :cholesterol, :saturated_fat, :trans_fat] },
    before_batch_import: proc { |import|
      import.csv_lines.uniq! {|line| line.first }
    }

  index do
    selectable_column
    id_column
    column :name
    column :weight
    column :calorie
    column :created_at
    column :updated_at
    actions
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
