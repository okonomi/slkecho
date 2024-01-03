# frozen_string_literal: true

module Slkecho
  class Options
    attr_accessor :channel, :subject, :message

    def initialize(channel: nil, subject: nil, message: nil)
      @channel = channel
      @subject = subject
      @message = message
    end
  end
end
