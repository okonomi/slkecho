# frozen_string_literal: true

module Slkecho
  module SlackRequest
    def self.send_request
      return unless block_given?

      response = yield
      raise Slkecho::SlackApiError, "API Response could not be retrieved." unless response.is_a?(Net::HTTPResponse)
      raise Slkecho::SlackApiHttpError, "#{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

      begin
        JSON.parse(response.body, symbolize_names: true)
      rescue JSON::ParserError
        raise Slkecho::SlackApiError, "API Response is not JSON."
      end
    end
  end
end
