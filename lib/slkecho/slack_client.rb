# frozen_string_literal: true

require_relative "slack_request/lookup_user_by_email"
require_relative "slack_request/post_message"

module Slkecho
  class SlackClient
    PostMessageParams = Slkecho::SlackRequest::PostMessage::Params

    def initialize(slack_api_token:)
      @slack_api_token = slack_api_token
    end

    def lookup_user_by_email(email:)
      Slkecho::SlackRequest::LookupUserByEmail.new(slack_api_token: @slack_api_token)
                                              .request(email: email)
    end

    def post_message(params)
      Slkecho::SlackRequest::PostMessage.new(slack_api_token: @slack_api_token)
                                        .request(params)
    end
  end
end
