# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

require_relative "../slack_request"

module Slkecho
  module SlackRequest
    class PostMessage
      Params = Struct.new(:channel, :blocks, :username, :icon_url, :icon_emoji, keyword_init: true)

      def initialize(slack_api_token:)
        @slack_api_token = slack_api_token

        @uri = URI.parse("https://slack.com/api/chat.postMessage")
        @http = Net::HTTP.new(@uri.host, @uri.port)
        @http.use_ssl = true
        @headers = {
          "Content-Type" => "application/json; charset=utf-8",
          "Authorization" => "Bearer #{slack_api_token}"
        }
      end

      def request(params)
        result = Slkecho::SlackRequest.send_request do
          @http.post(@uri.path, request_body(params).to_json, @headers)
        end

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
    end
  end
end
