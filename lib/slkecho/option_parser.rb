# frozen_string_literal: true

require "optparse"

module Slkecho
  class OptionParser
    def option_parser # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      @option_parser ||= ::OptionParser.new do |o|
        o.banner = "Usage: slkecho [options] message"
        o.program_name = "slkecho"
        o.version = Slkecho::VERSION
        o.on("-c", "--channel CHANNEL", "Slack channel to post message.") { @options.channel = _1 }
        o.on("-m", "--mention-by-email EMAIL", "Mention to user by email.") { @options.mention_by_email = _1 }
        o.on("--username USERNAME", "Set user name for message.") { @options.username = _1 }
        o.on("--icon-url ICON_URL", "Set user icon image for message by URL.") { @options.icon_url = _1 }
        o.on("--icon-emoji ICON_EMOJI", "Set user image for message by emoji.") { @options.icon_emoji = _1 }
        o.on("--message-as-blocks", "Post message as blocks.") { @options.message_as_blocks = true }
      end
    end

    def parse(argv)
      options = build_options(argv)
      validate_options(options)

      options
    end

    def build_options(argv)
      @options = Slkecho::Options.new
      argv = option_parser.parse(argv)

      @options.message = if !argv.empty?
                           argv.first
                         elsif !$stdin.tty?
                           $stdin.read.then { _1.empty? ? nil : _1 }
                         end

      @options.dup
    end

    def validate_options(options)
      raise Slkecho::InvalidOptionError, options.error_message unless options.valid?

      true
    end
  end
end
