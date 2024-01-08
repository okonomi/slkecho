# frozen_string_literal: true

module Slkecho
  class Configuration
    attr_accessor :slack_api_token

    def validate
      if slack_api_token.nil?
        raise Slkecho::InvalidConfigurationError.new("slack_api_token is required.", :slack_api_token)
      end

      true
    end
  end
end
