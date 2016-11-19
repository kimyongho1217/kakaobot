class ActiveAdmin::Devise::PasswordsController
  def after_resetting_password_path_for(resource)
    "/"
  end
end
