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
      user_id = mention_to_user_id(options.mention)

      @slack_client.post_message(
        channel: options.channel,
        message: options.message,
        subject: options.subject,
        user_id: user_id
      )
    end

    def mention_to_user_id(mention)
      return nil if mention.nil?

      return mention unless mention.include?("@")
      return mention if mention.start_with?("U")

      user = @slack_client.lookup_user_by_email(email: mention)
      user["id"]
    end

    def self.run(argv)
      # Slkecho.configuration.validate

      cli = new(
        option_parser: Slkecho::OptionParser.new,
        slack_client: Slkecho::SlackClient.new(slack_api_token: Slkecho.configuration.slack_api_token)
      )
      cli.run(argv)
    end
  end
end
