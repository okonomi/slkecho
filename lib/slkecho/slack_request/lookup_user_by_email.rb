# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

require_relative "../slack_request"

module Slkecho
  module SlackRequest
    class LookupUserByEmail
      def initialize(slack_api_token:)
        @slack_api_token = slack_api_token

        @uri = URI.parse("https://slack.com/api/users.lookupByEmail")
        host = @uri.host
        @http = Net::HTTP.new(host, @uri.port) unless host.nil?
        @http.use_ssl = true
        @headers = {
          "Authorization" => "Bearer #{slack_api_token}",
          "Content-Type" => "application/x-www-form-urlencoded"
        }
      end

      def request(email:)
        user_info = Slkecho::SlackRequest.send_request do
          @http.get(uri_with_query(@uri, { email: email }), @headers)
        end

        case user_info
        in { ok: true, user: user }
          user
        in { ok: false, error: error }
          raise Slkecho::SlackApiResultError, "user not found. (#{email})" if error == "users_not_found"

          raise Slkecho::SlackApiResultError, error
        end
      end

      def uri_with_query(uri, params)
        uri.dup.tap { _1.query = URI.encode_www_form(params) }
      end
    end
  end
end
