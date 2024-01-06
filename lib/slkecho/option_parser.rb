# frozen_string_literal: true

module Slkecho
  class OptionParser
    def option_parser
      @option_parser ||= ::OptionParser.new do |o|
        o.banner = "Usage: slkecho [options] message"
        o.program_name = "slkecho"
        o.version = Slkecho::VERSION
        o.on("-c", "--channel CHANNEL", "Slack channel to post the message") { @options.channel = _1 }
        o.on("-s", "--subject SUBJECT", "Subject of message") { @options.subject = _1 }
        o.on("-m", "--mention EMAIL", "Mention to user by email") { @options.mention = _1 }
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
      @options.message = argv.first unless argv.empty?

      @options.dup
    end

    def validate_options(options)
      # channel
      channel = options.channel
      raise Slkecho::InvalidOptionError, "channel is required." if channel.nil?
      unless channel.start_with?("#") || channel.start_with?("C")
        raise Slkecho::InvalidOptionError, "channel must start with # or C."
      end

      # mention
      unless options.mention.nil? || options.mention.include?("@")
        raise Slkecho::InvalidOptionError, "mention must be email."
      end

      # message
      raise Slkecho::InvalidOptionError, "message is missing." if options.message.nil?

      true
    end
  end
end
