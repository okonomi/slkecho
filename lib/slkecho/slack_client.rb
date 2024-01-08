# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

require_relative "slack_request/lookup_user_by_email"
require_relative "slack_request/post_message"

module Slkecho
  class SlackClient
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

    def lookup_user_by_email(email:)
      Slkecho::SlackRequest::LookupUserByEmail.new(slack_api_token: @slack_api_token)
                                              .request(email: email)
    end

    def post_message(channel:, message:, subject: nil, user_id: nil, username: nil, icon_url: nil)
      Slkecho::SlackRequest::PostMessage.new(slack_api_token: @slack_api_token)
                                        .request(channel: channel, message: message, subject: subject, user_id: user_id,
                                                 username: username, icon_url: icon_url)
    end
  end
end
