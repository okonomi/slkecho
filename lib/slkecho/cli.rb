# frozen_string_literal: true

require "optparse"

module Slkecho
  class CLI
    def initialize(option_parser:, slack_client:, blocks_builder:)
      @option_parser = option_parser
      @slack_client = slack_client
      @blocks_builder = blocks_builder
    end

    def run(argv)
      options = @option_parser.parse(argv)

      Slkecho.configuration.validate

      user_id = options.mention_by_email.nil? ? nil : email_to_user_id(options.mention_by_email)

      @slack_client.post_message(post_message_params_from(options, user_id))
    end

    def email_to_user_id(email)
      user = @slack_client.lookup_user_by_email(email: email)
      user["id"]
    end

    def post_message_params_from(options, user_id)
      blocks = if options.blocks
                 @blocks_builder.build_from_blocks(options.message, user_id)
               else
                 @blocks_builder.build_from_message(options.message, user_id)
               end

      Slkecho::SlackClient::PostMessageParams.new(
        channel: options.channel,
        blocks: blocks,
        username: options.username,
        icon_url: options.icon_url,
        icon_emoji: options.icon_emoji
      )
    end

    def self.run(argv)
      cli = new(
        option_parser: Slkecho::OptionParser.new,
        slack_client: Slkecho::SlackClient.new(slack_api_token: Slkecho.configuration.slack_api_token),
        blocks_builder: Slkecho::BlocksBuilder.new
      )
      cli.run(argv)
    end
  end
end
