class MessageController < ApplicationController
  include WitClient

  def wit_actions
    {
      send: -> (request, response) { send_to_kakao(request, response) },
      getCalories: -> (request) { get_calories(request) },
      eatFoods: -> (request) { eat_food(request) }
    }
  end

  def create
    ActiveRecord::Base.transaction do
      begin
        if @kakao_user.missing_info?
          @kakao_user.set_info params[:content]
          render json: @kakao_user.get_response
        else
          wit_client.run_actions(@kakao_user.session_id, params[:content], {})
        end
        @kakao_user.save if @kakao_user.changed?
      rescue  ApplicationError => e
        render json: { message: { text: e.message } }
      rescue => e
        Rails.logger.error e
        render json: { message: { text: "시스템오류입니다. 빨리 조치하도록 하겠습니다." } }
        raise ActiveRecord::Rollback
      end
    end
  end

  def send_to_kakao(request, response)
    render json: { message: { text: response['text'] } }
  end

  def eat_food(request)
    entities = serialize_entities(request['entities'])
    context = {}

    unless entities['Food']
      context['missingFood'] = true
      return context
    end

    meal = Meal.create(kakao_user: @kakao_user)

    # to keep original data as those are contained in context later
    numbers = entities['number'].dup
    food_units = entities['FoodUnit'].dup

    entities['Food'].each do |food_name|
      number = numbers.shift || 1
      food = Food.find_by(name: food_name)
      unless food
        context['missingFoodInfo'] = food_name
        return context
      end
      food_unit = FoodUnit.find_by(name: food_units.shift, food: food)
      meal.meal_foods << MealFood.new(food: food, food_unit: food_unit, count: number)
    end

    context['caloriesConsumed'] = meal.total_calorie_consumption
    context['foodConsumed'] = entities['Food'].join(", ")

    if entities['Food'].count == 1
      context['numberConsumed'] = entities['number'].first
      context['unitConsumed'] = entities['FoodUnit'].first || "개"
    end

    return context
  end

  def get_calories(_)
    context = {}
    context['caloriesConsumed'] = @kakao_user.calories_consumed
    context['caloriesRemaining'] = @kakao_user.calories_remaining
    return context
  end

end
