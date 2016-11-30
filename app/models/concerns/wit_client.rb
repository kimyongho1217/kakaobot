module WitClient
  extend ActiveSupport::Concern
  included do
    def self.set_entity
      wit_client.post_entities({
        id: self.name,
        lookups: ["keywords"]
      })
    end
  end

  class_methods do
    def send_to_wit
      class_name = self.class.name
      wit_client.delete_values(class_name, name) unless wit_added?
      res = wit_client.post_values(class_name, {
        value: name,
        expressions: synonyms
      })
      unless wit_added?
        self.wit_added = true
        self.save
      end
      res
    end

    private
    def wit_client
      @wit ||= Wit.new(access_token: ENV['WIT_TOKEN'], actions: actions)
    end

    def actions
      {
        send: -> (request, response) {
          puts("sending... #{response['text']}")
        }
      }
    end
  end
end
