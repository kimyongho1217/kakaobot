module WitClient
  extend ActiveSupport::Concern
  included do
    after_create :send_to_wit

    after_save do |me|
      return unless me.name_changed? or me.synonyms_changed?
      if me.name_changed?
        wit_client.delete_values(me.class.name, me.name_was) unless me.name_was.nil?
      else
        wit_client.delete_values(me.class.name, me.name)
      end
      me.send_to_wit
    end

    after_destroy do |me|
      wit_client.delete_values(me.class.name, me.name)
    end

    @actions = {
      send: -> (request, response) {
        puts("sending... #{response['text']}")
      }
    }
    @wit ||= Wit.new(access_token: ENV['WIT_TOKEN'], actions: @actions)

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

  private
  def wit_client
    @wit ||= Wit.new(access_token: ENV['WIT_TOKEN'], actions: @actions)
  end

end
