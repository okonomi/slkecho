# frozen_string_literal: true

module Slkecho
  class Options
    attr_accessor :channel, :subject, :mention, :message, :username

    def initialize(channel: nil, subject: nil, mention: nil, message: nil, username: nil)
      @channel = channel
      @subject = subject
      @mention = mention
      @message = message
      @username = username
    end
  end
end
