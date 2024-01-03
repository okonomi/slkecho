# frozen_string_literal: true

module Slkecho
  class OptionParser
    def option_parser
      @option_parser ||= ::OptionParser.new do |o|
        o.banner = "Usage: slkecho [options] message"

        o.on("-c", "--channel CHANNEL", "Slack channel to post the message") do |c|
          @options.channel = c
        end
        o.on("-s", "--subject SUBJECT", "Subject of message") do |s|
          @options.subject = s
        end
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
      raise Slkecho::InvalidOptionError, "channel is required." if options.channel.nil?
      raise Slkecho::InvalidOptionError, "channel must start with #." unless options.channel.start_with?("#")

      # message
      raise Slkecho::InvalidOptionError, "message is missing." if options.message.nil?

      true
    end
  end
end
