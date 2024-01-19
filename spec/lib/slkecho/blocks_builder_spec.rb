# frozen_string_literal: true

RSpec.describe Slkecho::BlocksBuilder do
  describe "#build_from_message" do
    subject { described_class.new.build_from_message(message, user_id) }

    let(:message) do
      "message"
    end

    context "when user_id is nil" do
      let(:user_id) { nil }

      it {
        expect(subject).to eq([
                                {
                                  "type" => "section",
                                  "text" => {
                                    "type" => "mrkdwn",
                                    "text" => message
                                  }
                                }
                              ])
      }
    end
  end

  describe "#build_from_blocks" do
    subject { described_class.new.build_from_blocks(blocks, user_id) }

    let(:blocks) do
      <<~JSON
        [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "<mention> message"
            }
          }
        ]
      JSON
    end

    context "when blocks are given" do
      let(:user_id) { "U012A3CDE" }

      it do
        expect(subject).to eq([
                                {
                                  "type" => "section",
                                  "text" => {
                                    "type" => "mrkdwn",
                                    "text" => "<@#{user_id}> message"
                                  }
                                }
                              ])
      end
    end
  end
end
