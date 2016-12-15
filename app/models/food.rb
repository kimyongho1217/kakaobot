class Food < ActiveRecord::Base
  include WitClient

  has_many :food_units
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :name_like, -> (query) {
    where("name like ?", "%#{query}%")
    .order("similarity(name, #{ActiveRecord::Base.connection.quote(query)}) DESC")
    .limit(12)
  }

  before_create do |food|
    food.name.strip!
  end

  after_save do |instance|
    next unless instance.name_changed? or instance.synonyms_changed?
    if instance.name_changed?
      wit_client.delete_values(instance.class.name, instance.name_was) unless instance.name_was.nil?
    else
      wit_client.delete_values(instance.class.name, instance.name_was)
    end
    instance.send_to_wit
  end

  after_destroy do |instance|
    wit_client.delete_values(instance.class.name, instance.name)
  end

  def self.set_entity
    @wit.post_entities({
      id: self.name,
      lookups: ["keywords"]
    })
  end

  def send_to_wit
    class_name = self.class.name
    wit_client.post_values(class_name, {
      value: name,
      expressions: [name] + synonyms
    })
  end

  def synonyms_raw
    self.synonyms.join("\n")
  end

  def synonyms_raw=(values)
    self.synonyms = []
    self.synonyms = values.split("\r\n")
  end

end
