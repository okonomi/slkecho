# frozen_string_literal: true

require_relative "slkecho/version"
require_relative "slkecho/configuration"
require_relative "slkecho/cli"
require_relative "slkecho/options"
require_relative "slkecho/option_parser"
require_relative "slkecho/slack_client"

module Slkecho
  class InvalidConfigurationError < StandardError; end
  class InvalidOptionError < StandardError; end
  class SlackRequestError < StandardError; end
  class SlackResponseError < StandardError; end

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
