class FoodUnit < ActiveRecord::Base
  belongs_to :food

  def synonyms_raw
    self.synonyms.join("\n")
  end

  def synonyms_raw=(values)
    self.synonyms = []
    self.synonyms = values.split("\r\n")
  end
end
