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
      response = @http.post(@uri.path, request_body(channel: options.channel, message: options.message, subject: options.subject).to_json, @headers)

      # レスポンスのチェック
      result = JSON.parse(response.body)
      return true if response.is_a?(Net::HTTPSuccess) && result["ok"]

      raise Slkecho::SlackResponseError, result["error"]
    rescue StandardError => e
      raise Slkecho::SlackRequestError, e.message
    end

    def request_body(channel:, message:, subject: nil, user_id: nil)
      body = {
        "channel" => channel,
        "blocks" => []
      }
      body["blocks"] << header_block(subject) unless subject.nil?
      body["blocks"] << section_block(message, user_id: user_id)

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