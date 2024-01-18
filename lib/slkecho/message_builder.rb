# frozen_string_literal: true

module Slkecho
  class MessageBuilder
    def build(message, user_id = nil, payload: false)
      if payload
        JSON.parse(message.gsub("<mention>", "<@#{user_id}>"))
      else
        {
          "blocks" => [
            {
              "type" => "section",
              "text" => {
                "type" => "mrkdwn",
                "text" => user_id.nil? ? message : "<@#{user_id}> #{message}"
              }
            }
          ]
        }
      end
    end
  end
end
