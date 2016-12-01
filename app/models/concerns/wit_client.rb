module WitClient
  extend ActiveSupport::Concern
  included do
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

    @actions = {
      send: -> (request, response) {
        puts("sending... #{response['text']}")
      }
    }
    @wit ||= Wit.new(access_token: ENV['WIT_TOKEN'], actions: @actions)

    attr_accessor   :names_raw

  end

  class_methods do
    def set_entity
      @wit.post_entities({
        id: self.name,
        lookups: ["keywords"]
      })
    end
  end

  def send_to_wit
    class_name = self.class.name
    wit_client.post_values(class_name, {
      value: name,
      expressions: synonyms
    })
  end

  def synonyms_raw
    self.synonyms.join("\n")
  end

  def synonyms_raw=(values)
    self.synonyms = []
    self.synonyms = values.split("\r\n")
  end

  private
  def wit_client
    @wit ||= Wit.new(access_token: ENV['WIT_TOKEN'], actions: @actions)
  end

end
