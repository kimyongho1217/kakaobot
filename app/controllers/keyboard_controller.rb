class KeyboardController < ApplicationController
  def show
    render json: { type: "buttons", buttons: ["선택1", "선택2"] }
  end

end
