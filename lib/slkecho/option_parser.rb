# frozen_string_literal: true

module Slkecho
  class OptionParser
    def option_parser # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      @option_parser ||= ::OptionParser.new do |o|
        o.banner = "Usage: slkecho [options] message"
        o.program_name = "slkecho"
        o.version = Slkecho::VERSION
        o.on("-c", "--channel CHANNEL", "Slack channel to post the message") { @options.channel = _1 }
        o.on("-s", "--subject SUBJECT", "Subject of message") { @options.subject = _1 }
        o.on("-m", "--mention EMAIL", "Mention to user by email") { @options.mention = _1 }
        o.on("--username USERNAME", "Set your bot's user name") { @options.username = _1 }
        o.on("--icon-url ICON_URL", "URL to an image to use as the icon for this message") { @options.icon_url = _1 }
        o.on("--icon-emoji ICON_EMOJI", "Emoji to use as the icon for this message") { @options.icon_emoji = _1 }
      end
    end

    def parse(argv)
      options = parse_options(argv)
      validate_options(options)

      options
    end

    def parse_options(argv)
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
      # channel
      channel = options.channel
      raise Slkecho::InvalidOptionError, "channel is required." if channel.nil?
      unless channel.start_with?("#") || channel.start_with?("C")
        raise Slkecho::InvalidOptionError, "channel must start with # or C."
      end

      # message
      raise Slkecho::InvalidOptionError, "message is missing." if options.message.nil?

      true
    end
  end
end
