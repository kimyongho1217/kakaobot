class KeyboardController < ApplicationController
  def show
    render json: { type: "buttons", buttons: ["칼로리를 알려줘"] }
  end

end
