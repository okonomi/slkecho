# frozen_string_literal: true

require "optparse"

module Slkecho
  class CLI
    def initialize(option_parser:, slack_client:)
      @option_parser = option_parser
      @slack_client = slack_client
    end

    def run(argv)
      options = @option_parser.parse(argv)
      @slack_client.post_message(options)
    end

    def self.run(argv)
      cli = new(
        option_parser: Slkecho::OptionParser.new,
        slack_client: Slkecho::SlackClient.new(slack_api_token: ENV["SLACK_API_TOKEN"])
      )
      cli.run(argv)
    end
  end
end
