# frozen_string_literal: true

require "optparse"

module Slkecho
  class OptionParser
    def option_parser # rubocop:disable Metrics/MethodLength
      @option_parser ||= ::OptionParser.new do |o|
        o.banner = "Usage: slkecho [options] message"
        o.program_name = "slkecho"
        o.version = Slkecho::VERSION
        o.on("--configure", "Configure Slack API token.")
        o.on("-c", "--channel CHANNEL", "Slack channel to post message.")
        o.on("-m", "--mention-by-email EMAIL", "Mention to user by email.")
        o.on("--username USERNAME", "Set user name for message.")
        o.on("--icon-url ICON_URL", "Set user icon image for message by URL.")
        o.on("--icon-emoji ICON_EMOJI", "Set user image for message by emoji.")
        o.on("--message-as-blocks", "Post message as blocks.")
        o.on("--token TOKEN", "Slack API token.")
      end
    end

    def parse(argv)
      options = build_options(argv)
      validate_options(options)

      options
    end

    def build_options(argv)
      option_values = {}
      argv = option_parser.parse(argv, into: option_values)
      option_values = option_values.transform_keys { _1.to_s.tr("-", "_") }

      Slkecho::Options.new(option_values).tap do |opt|
        opt.message = fetch_message(argv)
      end
    end

    def fetch_message(argv)
      if !argv.empty?
        argv.first
      elsif !$stdin.tty?
        $stdin.read.then { _1.empty? ? nil : _1 }
      end
    end

    def validate_options(options)
      raise Slkecho::InvalidOptionError, options.error_message unless options.valid?

      true
    end
  end
end
