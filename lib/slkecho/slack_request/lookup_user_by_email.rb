# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Slkecho
  module SlackRequest
    class LookupUserByEmail
      def initialize(slack_api_token:)
        @slack_api_token = slack_api_token

        @uri = URI.parse("https://slack.com/api/users.lookupByEmail")
        @http = Net::HTTP.new(@uri.host, @uri.port)
        @http.use_ssl = true
        @headers = {
          "Authorization" => "Bearer #{slack_api_token}",
          "Content-Type" => "application/x-www-form-urlencoded"
        }
      end

      def request(email:)
        begin
          response = @http.get(uri_with_query(@uri, { email: email }), @headers)
        rescue StandardError => e
          raise Slkecho::SlackApiHttpError, e.message
        end
        raise Slkecho::SlackApiHttpError, response.body unless response.is_a?(Net::HTTPSuccess)

        user_info = JSON.parse(response.body)
        raise Slkecho::SlackResponseError, "user not found. (#{email})" if user_info["error"] == "users_not_found"
        raise Slkecho::SlackResponseError, user_info["error"] unless user_info["ok"]

        user_info["user"]
      end

      def uri_with_query(uri, params)
        uri.dup.tap { _1.query = URI.encode_www_form(params) }
      end
    end
  end
end
