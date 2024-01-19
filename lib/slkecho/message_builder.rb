# frozen_string_literal: true

module Slkecho
  class MessageBuilder
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

    def build_from_blocks(blocks, user_id = nil)
      JSON.parse(blocks.gsub("<mention>", "<@#{user_id}>"))
    end
  end
end
