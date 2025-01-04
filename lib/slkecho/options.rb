# frozen_string_literal: true

require "active_model"

module Slkecho
  class Options
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :channel, :string
    attribute :mention_by_email, :string
    attribute :message, :string
    attribute :username, :string
    attribute :icon_url, :string
    attribute :icon_emoji, :string
    attribute :message_as_blocks, :boolean

    validates :channel, presence: true
    validates :message, presence: true, if: -> { message.nil? }
  end
end
