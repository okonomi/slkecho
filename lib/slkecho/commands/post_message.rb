# frozen_string_literal: true

module Slkecho
  module Commands
    class PostMessage
      def initialize(options)
        @options = options
      end

      def execute
        Slkecho.configuration.validate

        user_id = @options.mention_by_email.nil? ? nil : email_to_user_id(@options.mention_by_email)

        @slack_client.post_message(post_message_params_from(@options, user_id))

        puts "Message sent successfully."
      end
    end
  end
end
