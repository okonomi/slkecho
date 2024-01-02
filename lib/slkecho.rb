# frozen_string_literal: true

require_relative "slkecho/version"
require_relative "slkecho/cli"
require_relative "slkecho/slack_client"

module Slkecho
  class InvalidOptionError < StandardError; end
  class SlackRequestError < StandardError; end
  class SlackResponseError < StandardError; end
end
