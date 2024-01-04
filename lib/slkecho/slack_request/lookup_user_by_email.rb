# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Slkecho
  module SlackRequest
    class LookupUserByEmail
      def initialize(slack_api_token:)
        @slack_api_token = slack_api_token
      end

      def request(email:) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        uri = URI("https://slack.com/api/users.lookupByEmail")
        params = { email: email }
        uri.query = URI.encode_www_form(params)

        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{@slack_api_token}"
        request["Content-Type"] = "application/x-www-form-urlencoded"

        begin
          response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(request)
          end
        rescue StandardError => e
          raise Slkecho::SlackRequestError, e.message
        end

        raise Slkecho::SlackRequestError, response.body unless response.is_a?(Net::HTTPSuccess)

        user_info = JSON.parse(response.body)
        raise Slkecho::SlackResponseError, "user not found. (#{email})" if user_info["error"] == "users_not_found"
        raise Slkecho::SlackResponseError, user_info["error"] unless user_info["ok"]

        user_info["user"]
      end
    end
  end
end
