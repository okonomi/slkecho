# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Slkecho
  class SlackClient
    def initialize(slack_api_token:)
      @uri = URI.parse("https://slack.com/api/chat.postMessage")
      @http = Net::HTTP.new(@uri.host, @uri.port)
      @http.use_ssl = true
      @headers = {
        "Content-Type" => "application/json; charset=utf-8",
        "Authorization" => "Bearer #{slack_api_token}"
      }
    end

    def post_message(options)
      # HTTPリクエストを送信し、エラーをハンドルする
      response = @http.post(@uri.path, request_body(options).to_json, @headers)

      # レスポンスのチェック
      result = JSON.parse(response.body)
      return true if response.is_a?(Net::HTTPSuccess) && result["ok"]

      raise Slkecho::SlackResponseError, result["error"]
    rescue StandardError => e
      raise Slkecho::SlackRequestError, e.message
    end

    def request_body(options)
      body = {
        "channel" => options.channel,
        "blocks" => []
      }
      body["blocks"] << header_block(options.subject) unless options.subject.nil?
      body["blocks"] << context_block(options.message)

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

    def context_block(text)
      {
        "type" => "context",
        "elements" => [
          {
            "type" => "mrkdwn",
            "text" => text
          }
        ]
      }
    end
  end
end
