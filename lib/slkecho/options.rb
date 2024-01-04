# frozen_string_literal: true

module Slkecho
  class Options
    attr_accessor :channel, :subject, :mention, :message

    def initialize(channel: nil, subject: nil, mention: nil, message: nil)
      @channel = channel
      @subject = subject
      @mention = mention
      @message = message
    end
  end
end
