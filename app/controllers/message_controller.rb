class MessageController < ApplicationController

  def create
    context = wit_client.run_actions(@kakao_user.session_id, params[:content], @kakao_user.context || {})
    @kakao_user.context = context
    @kakao_user.save if @kakao_user.changed?
  end

  private
  def wit_client
    @wit ||= Wit.new(access_token: ENV['WIT_TOKEN'], actions: {
      send: -> (request, response) {
        render json: { message: { text: response['text'] } }
      },
      getCalories: -> (request) {
        kakao_user = KakaoUser.find_by(session_id: request["session_id"])
        context = request['context']
        context['caloriesConsumed'] = kakao_user.calories_consumed
        context['caloriesRemaining'] = kakao_user.calories_remaining
        return context
      },
      eatFoods: -> (request) {

      }
    })
  end
end
