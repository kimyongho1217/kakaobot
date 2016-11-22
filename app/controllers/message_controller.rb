class MessageController < ApplicationController
  def create
    render json: { message: { text: "챗봇앱이 준비중입니다"} }
  end
end
