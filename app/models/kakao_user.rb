class KakaoUser < ActiveRecord::Base
  include WitClient

  has_many :meals
  has_many :meals_today, -> { where("created_at >= ?", Time.now.beginning_of_day()) }, class_name: 'Meal'
  enum active_type: [:non, :light, :normal, :active, :athlete]

  before_save :calculate_recommended_calories!
  has_secure_token :session_id

  def calories_remaining
    recommended_calories - calories_consumed
  end

  def calories_consumed
    meals_today.sum(:total_calorie_consumption)
  end

  def missing_info?
    recommended_calories <= 0
  end

  def set_info(message)
    case
      when sex.blank?
        if message.match(/여자/)
          self.sex = "female"
        elsif message.match(/남자/)
          self.sex = "male"
        end
      when (age.nil? or age <= 0)
        self.age = get_wit_number message, "나이를 정확하게 인식하지 못하였습니다. 숫자로 입력해주세요"
      when (weight.nil? or weight <= 0)
        self.weight = get_wit_number message, "체중을 정확하게 인식하지 못하였습니다. 숫자로 입력해주세요"
      when (height.nil? or height <= 0)
        self.height = get_wit_number message, "신장을 정확하게 인식하지 못하였습니다. 숫자로 입력해주세요"
      when active_type.nil?
        self.active_type = case
          when message.match(/비활동적/)
            "non"
          when message.match(/가벼운활동/)
            "light"
          when message.match(/보통활동/)
            "normal"
          when message.match(/적극적활동/)
            "active"
          when message.match(/운동선수/)
            "athlete"
        end
    end
  end

  def get_response
    case
      when sex.blank?
        {
          message: { text: "성별을 입력해주세요."},
          keyboard: {
            type: "buttons",
            buttons: [
              "남자",
              "여자"
            ]
          }
        }
      when (age.nil? or age <= 0)
        {
          message:
          { text: "나이를 입력해주세요." }
        }
      when (weight.nil? or weight <= 0)
        {
          message:
          { text: "체중을 입력해주세요." }
        }
      when (height.nil? or height <= 0)
        {
          message:
          { text: "신장을 입력해주세요." }
        }
      when active_type.nil?
        {
          message: { text: "활동성향을 입력해주세요."},
          keyboard: {
            type: "buttons",
            buttons: [
              "비활동적",
              "가벼운활동",
              "보통활동",
              "적극적활동",
              "운동선수"
            ]
          }
        }
    end
  end

  private

  def get_wit_number(message, error_message)
    rsp = wit_client.message(message)
    entities = serialize_entities(rsp["entities"])
    unless entities.has_key?("number")
      raise ApplicationError.new(error_message)
    end
    entities["number"].to_i
  end

  def calculate_recommended_calories!
    return if !age_changed? and !sex_changed? and !height_changed? and !weight_changed? and !active_type_changed?
    if [age, height, weight].any? { |item| item.nil? or item <= 0 } or sex.blank? or active_type.nil?
      recommended_calories = 0
    else
      if sex == "male"
        recommended_calories = (weight * 10) + (height * 6.25) - (age * 5) + 5
      else
        recommended_calories = (weight * 10) + (height * 6.25) - (age * 5) - 161
      end
      recommended_calories *= {
        "non": 1.2,
        "light": 1.375,
        "normal": 1.555,
        "active": 1.725,
        "athlete": 1.9
      }[active_type.to_sym]
    end
    self.recommended_calories = recommended_calories
  end
end
