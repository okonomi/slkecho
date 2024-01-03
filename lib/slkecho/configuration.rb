# frozen_string_literal: true

module Slkecho
  class Configuration
    attr_accessor :slack_api_token

    def validate
      raise Slkecho::InvalidConfigurationError, "slack_api_token is required." if slack_api_token.nil?

      true
    end
  end
end
