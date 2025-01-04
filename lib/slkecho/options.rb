# frozen_string_literal: true

module Slkecho
  class Options
    attr_accessor :channel, :mention_by_email, :message, :username, :icon_url, :icon_emoji, :message_as_blocks
    attr_reader :errors

    def initialize
      @errors = []
    end

    def validate
      @errors = []

      @errors << "channel is required." if channel.nil?
      @errors << "message is missing." if message.nil?

      @errors
    end

    def valid?
      validate
      @errors.empty?
    end
  end
end
