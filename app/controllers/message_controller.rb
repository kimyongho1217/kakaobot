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
        puts request
        entities = serialize_entities(request['entities'])
        context = request['context']
        context.merge! entities
        unless context['Food'] 
          context['missingFood'] = true
          return context
        end

        unless context['FoodUnit'] 
          context['missingUnit'] = true
          return context
        end

        unless context['number'] 
          context['missingNumber'] = true
          return context
        end

        food = Food.find_by(name: context['Food'])
        unless food
          context['missingFoodInfo'] = context['Food']
          return context
        end
        food_unit = FoodUnit.find_or_create_by(name: context['FoodUnit'], food: food)
        meal = Meal.create(kakao_user: @kakao_user)
        if entities["datetime"]
          entities["datetime"]
          meal.ate_at = entities["datetime"]
        end
        return context
      }
    })
  end

  def serialize_entities(entities)
    entities.reduce({}) do |m, entity|
      m.merge!(entity[0] => entity[1][0].has_key?('value') ? entity[1][0]['value'] : entity[1][0])
    end
  end

end
