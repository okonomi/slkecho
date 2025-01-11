# frozen_string_literal: true

require_relative "command/configure_user_token"
require_relative "command/post_message"

module Slkecho
  class CLI
    def initialize(option_parser:)
      @option_parser = option_parser
    end

    def run(argv)
      options = @option_parser.parse(argv)

      if options.configure
        Slkecho::Command::ConfigureUserToken.new.execute
      else
        Slkecho::Command::PostMessage.new(
          blocks_builder: Slkecho::BlocksBuilder.new,
          options: options
        ).execute
      end
    end

    def self.run(argv)
      cli = new(
        option_parser: Slkecho::OptionParser.new
      )
      cli.run(argv)
    end
  end
end
