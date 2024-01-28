# frozen_string_literal: true

require_relative "slkecho/version"
require_relative "slkecho/configuration"
require_relative "slkecho/cli"
require_relative "slkecho/options"
require_relative "slkecho/option_parser"
require_relative "slkecho/slack_client"
require_relative "slkecho/blocks_builder"

module Slkecho
  class InvalidConfigurationError < StandardError
    attr_reader :item

    def initialize(message, item = nil)
      @item = item
      super(message)
    end
  end

  class InvalidOptionError < StandardError; end
  class SlackApiError < StandardError; end
  class SlackApiHttpError < StandardError; end
  class SlackApiResultError < StandardError; end

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
