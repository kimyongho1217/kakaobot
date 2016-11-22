class FriendController < ApplicationController
  def create
    kakao_user = KakaoUser.first_or_create(user_key: params[:user_key])
    unless kakao_user.active?
      kakao_user.active = true
      kakao_user.save
    end
    render json: { message: "SUCCESS", comment: "정상 응답" }
  end

  def destroy
    kakao_user = KakaoUser.find_by(user_key: params[:user_key])
    unless kakao_user.nil?
      kakao_user.active = false
      kakao_user.save
    end
    render json: { message: "SUCCESS", comment: "정상 응답" }
  end
end
