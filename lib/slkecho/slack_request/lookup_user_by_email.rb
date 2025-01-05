# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

require_relative "../slack_request"
require_relative "../http"

module Slkecho
  module SlackRequest
    class LookupUserByEmail
      def initialize(slack_api_token:)
        @slack_api_token = slack_api_token
      end

      def request(email:)
        user_info = send_request(email, @slack_api_token)
        case user_info
        in { ok: true, user: user }
          user
        in { ok: false, error: error }
          raise Slkecho::SlackApiResultError, "user not found. (#{email})" if error == "users_not_found"

          raise Slkecho::SlackApiResultError, error
        end
      end

      private

      def send_request(email, token)
        Slkecho::SlackRequest.send_request do
          uri = uri_with_query("https://slack.com/api/users.lookupByEmail", { email: email })
          headers = {
            "Authorization" => "Bearer #{token}",
            "Content-Type" => "application/x-www-form-urlencoded"
          }
          Slkecho::HTTP.get(uri, headers: headers)
        end
      end

      def uri_with_query(uri, params)
        URI(uri).tap { _1.query = URI.encode_www_form(params) }
      end
    end
  end
end
