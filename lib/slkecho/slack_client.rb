# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Slkecho
  class SlackClient
    def post_message(options) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      uri = URI.parse("https://slack.com/api/chat.postMessage")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      headers = {
        "Content-Type" => "application/json; charset=utf-8",
        "Authorization" => "Bearer #{ENV["SLACK_API_TOKEN"]}" # 環境変数からトークンを取得
      }
      body = {
        "channel" => options.channel,
        "blocks" => []
      }

      unless options.subject.nil?
        body["blocks"] << {
          "type" => "header",
          "text" => {
            "type" => "plain_text",
            "text" => options.subject,
            "emoji" => true
          }
        }
      end

      body["blocks"] << {
        "type" => "context",
        "elements" => [
          {
            "type" => "mrkdwn",
            "text" => options.message
          }
        ]
      }

      # HTTPリクエストを送信し、エラーをハンドルする
      begin
        response = http.post(uri.path, body.to_json, headers)

        # レスポンスのチェック
        result = JSON.parse(response.body)
        return true if response.is_a?(Net::HTTPSuccess) && result["ok"]

        raise Slkecho::SlackResponseError, result["error"]
      rescue StandardError => e
        raise Slkecho::SlackRequestError, e.message
      end
    end
  end
end
