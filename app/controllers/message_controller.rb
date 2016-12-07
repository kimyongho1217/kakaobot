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
        get_calories(request)
      },
      eatFoods: -> (request) {
        eat_food(request)
      }
    })
    @wit.logger.level = Logger::DEBUG
    @wit
  end

  def eat_food(request)
    entities = serialize_entities(request['entities'])
    context = request['context']
    unless entities['Food'] 
      context['missingFood'] = true
      return context
    end

    unless entities['FoodUnit'] 
      context['missingUnit'] = true
      return context
    end

    unless entities['number'] 
      context['missingNumber'] = true
      return context
    end

    food = Food.find_by(name: entities['Food'])

    unless food
      context['missingFoodInfo'] = entities['Food']
      return context
    end

    food_unit = FoodUnit.find_or_create_by(name: entities['FoodUnit'], food: food)
    meal = Meal.create(kakao_user: @kakao_user)
    meal.meal_foods << MealFood.new(food: food, food_unit: food_unit, count: entities['number'])
    context['caloriesConsumed'] = meal.total_calorie_consumption

    return context
  end

  def get_calories(request)
    entities = serialize_entities(request['entities'])
    context = request['context']
    context.merge! entities

    if %w[sex age weight height].any? {|k| context[k].present? }
      @kakao_user.sex = entities['sex'] if entities['sex']
      @kakao_user.age = entities['number'] if entities['age']
      @kakao_user.height = entities['number'] if entities['height']
      @kakao_user.weight = entities['number'] if entities['weight']
      @kakao_user.save
    end

    if @kakao_user.recommended_calories <= 0
      if @kakao_user.sex.blank?
        context['missingSex'] = true
      elsif @kakao_user.age.nil? or @kakao_user.age <= 0
        context['missingAge'] = true
      elsif @kakao_user.height.nil? or @kakao_user.height <= 0
        context['missingHeight'] = true
      elsif @kakao_user.weight.nil? or @kakao_user.weight <= 0
        context['missingWeight'] = true
      end
      return context
    end
    context['caloriesConsumed'] = @kakao_user.calories_consumed
    context['caloriesRemaining'] = @kakao_user.calories_remaining
    return context
  end

  def serialize_entities(entities)
    entities.reduce({}) do |m, entity|
      m.merge!(entity[0] => entity[1][0].has_key?('value') ? entity[1][0]['value'] : entity[1][0])
    end
  end
end
