# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

require_relative "../http"
require_relative "../slack_request"

module Slkecho
  module SlackRequest
    class PostMessage
      Params = Struct.new(:channel, :blocks, :username, :icon_url, :icon_emoji, keyword_init: true) do
        def to_request_body
          JSON.dump({
                      channel: channel,
                      blocks: blocks,
                      username: username,
                      icon_url: icon_url,
                      icon_emoji: icon_emoji
                    })
        end
      end

      def initialize(slack_api_token:)
        @slack_api_token = slack_api_token
      end

      def request(params)
        result = send_request(@slack_api_token, params)
        case result
        in { ok: true }
          true
        in { ok: false, error: error }
          raise Slkecho::SlackApiResultError, error
        end
      end

      private

      def send_request(token, params)
        Slkecho::SlackRequest.send_request do
          url = "https://slack.com/api/chat.postMessage"
          headers = {
            "Content-Type" => "application/json; charset=utf-8",
            "Authorization" => "Bearer #{token}"
          }
          body = params.to_request_body

          Slkecho::HTTP.post(url, headers: headers, body: body)
        end
      end
    end
  end
end
