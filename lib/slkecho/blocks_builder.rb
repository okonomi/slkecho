# frozen_string_literal: true

require "json"

module Slkecho
  class BlocksBuilder
    def build_from_message(message, user_id = nil)
      [
        {
          "type" => "section",
          "text" => {
            "type" => "mrkdwn",
            "text" => user_id.nil? ? message : "<@#{user_id}> #{message}"
          }
        }
      ]
    end

    def build_from_json(json, user_id = nil)
      JSON.parse(json.gsub("<mention>", "<@#{user_id}>"))
    end
  end
end
