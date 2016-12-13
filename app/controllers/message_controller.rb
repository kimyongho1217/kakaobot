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
          res = @kakao_user.get_response

        elsif params[:content] == "먹은 음식 적기"
          res = { message: { text: "안녕하세요. 식사 잘 하셨나요? ^^\n"\
                                   "아래와 같이 적어주세요.\n"\
                                   "\"고구마 1개, 바나나 1개\"\n"\
                                   "\"아메리카노\"" } }
        elsif params[:content] == "도움말"
          res = { message: { text:  "아래와 같이 적어보세요\n"\
                                    "\"아메리카노\"\n"\
                                    "\"고구마 1개, 바나나 1개\"\n"\
                                    "\"오늘 얼마나 먹었지?\"\n"\
                                    "\"남은 칼로리\"" } }
        else
          @rsp = wit_client.async.run_actions(@kakao_user.session_id, params[:content], {})
          res = { message: { text: @rsp.value! } }
        end

        render json: res
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

  def send_to_kakao(_request, response)
    @rsp.set response['text']
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
    numbers = entities['number'].dup rescue []
    food_units = entities['FoodUnit'].dup rescue []

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

    context['foodConsumed'] = meal.meal_foods.includes(:food).map {|meal_food|
      "#{meal_food.food.name} #{meal_food.calorie_consumption}"
    }.join(", ")
    context['caloriesConsumed'] = meal.total_calorie_consumption
    context['caloriesRemaining'] = @kakao_user.calories_remaining


    return context
  end

  def get_calories(_)
    context = {}
    context['caloriesConsumed'] = @kakao_user.calories_consumed
    context['caloriesRemaining'] = @kakao_user.calories_remaining
    return context
  end
end
