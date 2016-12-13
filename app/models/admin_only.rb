class AdminOnly < ActiveAdmin::AuthorizationAdapter
  def authorized?(_action, _subject = nil)
    user.admin?
  end
end
