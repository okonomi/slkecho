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

      user = options.mention.nil? ? nil : @slack_client.lookup_user_by_email(email: options.mention)

      @slack_client.post_message(
        channel: options.channel,
        message: options.message,
        subject: options.subject,
        user_id: user["id"]
      )
    end

    def self.run(argv)
      Slkecho.configuration.validate

      cli = new(
        option_parser: Slkecho::OptionParser.new,
        slack_client: Slkecho::SlackClient.new(slack_api_token: Slkecho.configuration.slack_api_token)
      )
      cli.run(argv)
    end
  end
end
