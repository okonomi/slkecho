# frozen_string_literal: true

require "optparse"

module Slkecho
  class CLI
    def run(argv)
      option_parser = Slkecho::OptionParser.new
      options = option_parser.parse(argv)

      client = Slkecho::SlackClient.new
      client.post_message(options)
    end
  end
end
