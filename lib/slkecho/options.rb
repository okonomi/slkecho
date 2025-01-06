# frozen_string_literal: true

require "active_model"

module Slkecho
  class Options
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :configure, :boolean
    attribute :channel, :string
    attribute :mention_by_email, :string
    attribute :message, :string
    attribute :username, :string
    attribute :icon_url, :string
    attribute :icon_emoji, :string
    attribute :message_as_blocks, :boolean
    attribute :token, :string

    validates :channel, presence: { message: "is required." }, unless: -> { configure }
    validates :message, presence: { message: "is missing." }, unless: -> { configure || !message.nil? }

    def error_message
      errors.full_messages.join(" ").downcase
    end
  end
end
