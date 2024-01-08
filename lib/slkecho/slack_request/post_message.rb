# frozen_string_literal: true

module Slkecho
  module SlackRequest
    class PostMessage
      Params = Struct.new(:channel, :message, :subject, :user_id, :username, :icon_url, keyword_init: true)

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
        response = @http.post(
          @uri.path,
          request_body(params).to_json,
          @headers
        )
        raise Slkecho::SlackRequestError, response.body unless response.is_a?(Net::HTTPSuccess)

        result = JSON.parse(response.body)
        raise Slkecho::SlackResponseError, result["error"] unless result["ok"]

        true
      end

      def request_body(params)
        body = {
          "channel" => params.channel,
          "blocks" => [],
          "username" => params.username,
          "icon_url" => params.icon_url
        }
        body["blocks"] << header_block(params.subject) unless params.subject.nil?
        body["blocks"] << section_block(params.message, user_id: params.user_id)

        body
      end

      def header_block(text)
        {
          "type" => "header",
          "text" => {
            "type" => "plain_text",
            "text" => text,
            "emoji" => true
          }
        }
      end

      def section_block(text, user_id: nil)
        {
          "type" => "section",
          "text" => {
            "type" => "mrkdwn",
            "text" => user_id.nil? ? text : "<@#{user_id}> #{text}"
          }
        }
      end
    end
  end
end
