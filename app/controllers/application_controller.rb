class ApplicationController < ActionController::Base
  before_filter :set_kakao_user
  #around_filter :transaction_wrap

  def access_denied(exception)
    reset_session
    redirect_to :root, :alert => exception.message
  end

  def set_kakao_user
    return unless params[:user_key]
    @kakao_user = KakaoUser.find_or_create_by(user_key: params[:user_key])
    @kakao_user.regenerate_session_id if @kakao_user.session_id.nil?
    @kakao_user.active = true unless @kakao_user.active?
    @kakao_user.save
  end

  def transaction_wrap
    ActiveRecord::Base.transaction do
      yield
    end
  end
end
