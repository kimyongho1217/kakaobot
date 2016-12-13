class KeyboardController < ApplicationController
  def show
    render json: { type: "buttons", buttons: ["먹은 음식 적기", "남은 칼로리 보기", "도움말"] }
  end
end
