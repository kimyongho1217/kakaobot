class KeyboardController < ApplicationController
  def show
    render json: { type: "buttons", buttons: ["선택1", "선택2", "선택3", "선택4", "선택5", "선택6"] }
  end

end
