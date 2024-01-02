# frozen_string_literal: true

require "optparse"

module Slkecho
  class CLI
    Options = Struct.new(:channel, :subject, :message, keyword_init: true)

    def self.parse_options(argv) # rubocop:disable Metrics/MethodLength
      # コマンドライン引数を解析する
      options = Slkecho::CLI::Options.new
      opts = OptionParser.new do |o|
        o.banner = "Usage: echo2slack.rb [options] or echo | echo2slack.rb [options]"

        o.on("-c", "--channel CHANNEL", "Slack channel to post the message") do |c|
          options.channel = c
        end
        o.on("-s", "--subject SUBJECT", "Subject of message") do |s|
          options.subject = s
        end
      end
      argv = opts.parse(argv)

      options.message = argv.first unless argv.empty?

      options
    end

    def self.validate_options(options)
      # チャンネル名のバリデーション
      raise Slkecho::InvalidOptionError, "channel is required." if options[:channel].nil?
      raise Slkecho::InvalidOptionError, "channel must start with #." unless options[:channel].start_with?("#")

      # メッセージのバリデーション
      raise Slkecho::InvalidOptionError, "message is missing." if options[:message].nil?

      true
    end

    def self.start(argv)
      options = parse_options(argv)
      validate_options(options)

      client = Slkecho::SlackClient.new
      client.post_message(options)
    end
  end
end
