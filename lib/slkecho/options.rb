# frozen_string_literal: true

module Slkecho
  class Options
    attr_accessor :channel, :subject, :mention, :message, :username, :icon_url

    def initialize(channel: nil, subject: nil, mention: nil, message: nil, username: nil, icon_url: nil)
      @channel = channel
      @subject = subject
      @mention = mention
      @message = message
      @username = username
      @icon_url = icon_url
    end
  end
end
