module WitClient
  extend ActiveSupport::Concern
  included do
    cattr_accessor :actions
    cattr_accessor :wit
    self.actions = {
      send: -> (_, response) { puts("sending... #{response['text']}") }
    }
  end

  class_methods do
    def set_wit_actions(actions)
      self.actions = actions
    end

    def wit_client
      self.wit ||= Wit.new(access_token: ENV['WIT_TOKEN'], actions: self.actions)
    end
  end

  def wit_client
    self.wit ||= Wit.new(access_token: ENV['WIT_TOKEN'], actions: self.actions)
  end

  def serialize_entities(entities)
    entities.reduce({}) do |m, entity|
      m.merge!(entity[0] => entity[1][0].has_key?('value') ? entity[1][0]['value'] : entity[1][0])
    end
  end
end
