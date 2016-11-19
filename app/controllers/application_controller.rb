class ApplicationController < ActionController::Base
  def access_denied(exception)
    reset_session
    redirect_to :root, :alert => exception.message
  end
end
