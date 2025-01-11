# frozen_string_literal: true

require_relative "../slack_client"

module Slkecho
  class Command
    class PostMessage
      def initialize(blocks_builder:, options:)
        @blocks_builder = blocks_builder
        @options = options
      end

      def execute
        slack_client = Slkecho::SlackClient.new(slack_api_token: @options.token)
        user_id = @options.mention_by_email.nil? ? nil : email_to_user_id(slack_client, @options.mention_by_email)
        slack_client.post_message(post_message_params_from(@options, user_id))

        puts "Message sent successfully."
      end

      private

      def email_to_user_id(slack_client, email)
        user = slack_client.lookup_user_by_email(email: email)
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
    end
  end
end
