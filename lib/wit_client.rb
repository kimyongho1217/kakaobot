module WitClient
  extend ActiveSupport::Concern

  class WitWrapper < Wit
    include Concurrent::Async
  end

  included do
    mattr_accessor :actions
    mattr_accessor :wit
    self.actions = {
      send: -> (_, response) { puts("sending... #{response['text']}") }
    }
  end

  class_methods do
    def wit_client
      self.wit ||= Wit.new(access_token: ENV['WIT_TOKEN'], actions: self.actions)
    end

  end

  def wit_client
    @wit ||= WitWrapper.new(access_token: ENV['WIT_TOKEN'], actions: self.respond_to?(:wit_actions) ? wit_actions : self.actions)
#    @wit.logger.level = Logger::DEBUG
#    @wit
  end

  def serialize_entities(entities)
    entities.reduce({}) do |m, entity|
      m.merge!(entity[0] => entity[1].map {|item| item.has_key?('value') ? item['value'] : item })
    end
  end
end
