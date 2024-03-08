# frozen_string_literal: true

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
      user[:id]
    end

    def post_message_params_from(options, user_id)
      Slkecho::SlackClient::PostMessageParams.new(
        channel: options.channel,
        blocks: blocks_from(options.message, user_id, options.message_as_blocks),
        username: options.username,
        icon_url: options.icon_url,
        icon_emoji: options.icon_emoji
      )
    end

    def blocks_from(message, user_id, message_as_blocks)
      if message_as_blocks
        @blocks_builder.build_from_json(message, user_id)
      else
        @blocks_builder.build_from_message(message, user_id)
      end
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
