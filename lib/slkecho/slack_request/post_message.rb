# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

require_relative "../http"
require_relative "../slack_request"

module Slkecho
  module SlackRequest
    class PostMessage
      Params = Struct.new(:channel, :blocks, :username, :icon_url, :icon_emoji, keyword_init: true)

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

      def request_body(params)
        {
          channel: params.channel,
          blocks: params.blocks,
          username: params.username,
          icon_url: params.icon_url,
          icon_emoji: params.icon_emoji
        }
      end

      private

      def send_request(token, params)
        Slkecho::SlackRequest.send_request do
          uri = URI("https://slack.com/api/chat.postMessage")
          headers = {
            "Content-Type" => "application/json; charset=utf-8",
            "Authorization" => "Bearer #{token}"
          }
          body = request_body(params).to_json

          Slkecho::HTTP.post(uri, headers: headers, body: body)
        end
      end
    end
  end
end
