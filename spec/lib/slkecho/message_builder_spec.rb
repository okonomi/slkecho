# frozen_string_literal: true

RSpec.describe Slkecho::MessageBuilder do
  describe "#build" do
    subject { described_class.new.build(message, user_id) }

    let(:message) do
      "message"
    end

    context "when user_id is nil" do
      let(:user_id) { nil }

      it {
        expect(subject).to eq({
                                "blocks" => [
                                  {
                                    "type" => "section",
                                    "text" => {
                                      "type" => "mrkdwn",
                                      "text" => message
                                    }
                                  }
                                ]
                              })
      }
    end

    context "when blocks are given" do
      subject do
        described_class.new.build(<<~PAYLOAD, user_id, payload: true)
          {
            "blocks": [
              {
                "type": "section",
                "text": {
                  "type": "mrkdwn",
                  "text": "<mention> message"
                }
              }
            ]
          }
        PAYLOAD
      end

      let(:user_id) { "U012A3CDE" }

      it do
        expect(subject).to eq({
                                "blocks" => [
                                  {
                                    "type" => "section",
                                    "text" => {
                                      "type" => "mrkdwn",
                                      "text" => "<@#{user_id}> message"
                                    }
                                  }
                                ]
                              })
      end
    end
  end
end
