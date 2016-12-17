class MessageController < ApplicationController
  include WitClient

  def wit_actions
    {
      send: -> (_request, response) {
        send_to_kakao({ message: { text: response['text'] } })
      },
      getCalories: -> (request) { get_calories(request) },
      eatFoods: -> (request) { eat_food(request) },
      searchFood: -> (request) { search_food(request) },
      askQuantity: -> (request) { ask_quantity(request) }
    }
  end

  def create
    ActiveRecord::Base.transaction do
      begin
        case
        when @kakao_user.missing_info?
          @kakao_user.set_info params[:content]
          res = @kakao_user.get_response

        when params[:content] == "먹은 음식 적기"
          res = { message: { text: "안녕하세요. 식사 잘 하셨나요? ^^\n"\
                                   "아래 예시와 같이 적어주시면 칼로리가 기록됩니다.\n"\
                                   "\"고구마 1개, 바나나 1개\"\n"\
                                   "\"아메리카노\"" } }
        when params[:content] == "도움말"
          res = { message: { text:  "아래와 같이 적어보세요\n"\
                                    "\"아메리카노\"\n"\
                                    "\"고구마 1개, 바나나 1개\"\n"\
                                    "\"오늘 얼마나 먹었지?\"\n"\
                                    "\"남은 칼로리\"" } }
        else
          @rsp = wit_client.async.run_actions(@kakao_user.session_id, params[:content], @kakao_user.context || {})
          res = @rsp.value!
        end

        render json: res
        @kakao_user.save if @kakao_user.changed?
      rescue  ApplicationError => e
        render json: { message: { text: e.message } }
      rescue => e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")
        render json: { message: { text: "시스템오류입니다. 빨리 조치하도록 하겠습니다." } }
        raise ActiveRecord::Rollback
      end
    end
  end

  def send_to_kakao(response)
    @rsp.set response
  end

  def merge_context(current, context)
    return current unless context['previous_entities']

    previous = context['previous_entities']
    if context['ambiguousUnit']
      i = previous['FoodUnit'].index(context['ambiguousUnit'])

      # replacing exsting ambiguous unit with new one
      previous['FoodUnit'][i] = current['FoodUnit'][0]

      if previous.has_key?("number")
        previous['number'].insert(i, (current['number'][0] rescue 1))
      else
        previous['number'] = current['number'] || []
      end

    elsif context['missingFood']
      previous['Food'] = current['Food']

    elsif context['searchFood']
      i = previous['Food'].index(context['searchFood'])
      # replacing exsting ambiguous unit with new one
      previous['Food'][i] = current['Food'][0]
    end
    current.merge(previous).merge(context.except("previous_entities"))
  end

  def eat_food(request)
    entities = merge_context(serialize_entities(request['entities']), request['context'])
    context = {}

    unless entities['Food']
      context['missingFood'] = true
      @kakao_user.context = context.merge(previous_entities: entities)
      return context
    end

    if entities['number'].nil? \
      and entities['FoodUnit'].nil? \
      and entities['Food'].count > 1 \
      and Food.where(name: entities['Food'].join).exists?
      entities['Food'] = [entities['Food'].join]
    end

    #puts "========================================"
    #puts entities
    #puts "========================================"

    # to keep original data as those are contained in context later
    numbers = entities['number'].dup rescue []
    food_units = entities['FoodUnit'].dup rescue []

    food_units.each do |food_unit|
      next unless %w[약간 조금 많이].include? food_unit
      context['ambiguousUnit'] = food_unit
      @kakao_user.context = context.merge(previous_entities: entities)
      return context
    end

    meal = Meal.create(kakao_user: @kakao_user)

    missingFoodInfo = []
    entities['Food'].each do |food_name|
      number = numbers.shift

      foods = Food.name_like(food_name)

      if foods.empty?
        missingFoodInfo << food_name
        next
      end

      unless number
        context['missingNumber'] = food_name
        @kakao_user.context = context.merge(previous_entities: entities)
        return context
      end

      if foods.count > 1 and entities["searchFood"].nil?
        context['searchFood'] = food_name
        @kakao_user.context = context.merge(previous_entities: entities)
        return context
      end
      food = foods.find_by(name: food_name)
      food_unit = FoodUnit.find_by(name: food_units.shift, food: food)
      meal.meal_foods << MealFood.new(food: food, food_unit: food_unit, count: number)
    end

    context['missingFoodInfo'] = missingFoodInfo.join(", ") unless missingFoodInfo.empty?
    return context if missingFoodInfo.count == entities['Food'].count

    if meal.meal_foods.count > 1
      context['foodConsumed'] = meal.meal_foods.includes(:food).map do |meal_food|
        "#{meal_food.food.name} #{meal_food.calorie_consumption}"
      end.join(", ")
      context['multiFood'] = true if meal.meal_foods.count > 1
    else
      meal_food = meal.meal_foods[0]
      count = meal_food.count < 1 ? meal_food.count : meal_food.count.round
      context['foodConsumed'] = "#{meal_food.food.name} #{count}#{meal_food.food_unit.name rescue "개"}"
    end

    context['caloriesConsumed'] = meal.total_calorie_consumption
    if @kakao_user.calories_remaining > 0
      context['caloriesRemaining'] = @kakao_user.calories_remaining
    else
      context['caloriesOver'] = @kakao_user.calories_remaining * -1
    end
    @kakao_user.context = {} unless @kakao_user.context.blank?
    return context
  end

  def get_calories(_)
    context = {}
    context['caloriesConsumed'] = @kakao_user.calories_consumed
    if @kakao_user.calories_remaining > 0
      context['caloriesRemaining'] = @kakao_user.calories_remaining
    else
      context['caloriesOver'] = @kakao_user.calories_remaining * -1
    end
    @kakao_user.context = {} unless @kakao_user.context.blank?
    return context
  end

  def search_food(request)
		search_query = serialize_entities(request['entities'])['Food'][0] rescue nil
    search_query ||= request['context']['searchFood']
    foods = Food.name_like(search_query)

    if foods.empty?
      msg = { message: { text: "죄송합니다. 검색결과가 없습니다" } }
    else
      msg = {
        message: { text: "어떤 #{search_query} 인가요?"},
        keyboard: {
          type: "buttons",
          buttons: foods.map(&:name)
        }
      }
    end
    send_to_kakao msg
    return { }
  end

  def ask_quantity(request)
    unit = Food.find_by(name: request['context']['missingNumber']).food_units[0].name rescue "개"

    send_to_kakao({
      message: { text: "#{request['context']['missingNumber']}를 얼마나 드셨나요?"},
      keyboard: {
        type: "buttons",
        buttons: [
          "0.5#{unit}",
          "1#{unit}",
          "2#{unit}"
        ]
      }
    })
    return { }
  end
end
