class ActiveAdmin::Devise::ConfirmationsController
  def after_confirmation_path_for(resource_name, resource)
    "/"
  end
end
