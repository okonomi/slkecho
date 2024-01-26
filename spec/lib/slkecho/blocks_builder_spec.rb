# frozen_string_literal: true

RSpec.describe Slkecho::BlocksBuilder do
  describe "#build_from_message" do
    subject { described_class.new.build_from_message("message", user_id) }

    context "when user_id is nil" do
      let(:user_id) { nil }
      let(:blocks) do
        [
          {
            type: "section",
            text: {
              type: "mrkdwn",
              text: "message"
            }
          }
        ]
      end

      it { is_expected.to eq(blocks) }
    end
  end

  describe "#build_from_json" do
    subject do
      described_class.new.build_from_json(<<~JSON, user_id)
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
      let(:blocks) do
        [
          {
            "type" => "section",
            "text" => {
              "type" => "mrkdwn",
              "text" => "<@#{user_id}> message"
            }
          }
        ]
      end

      it { is_expected.to eq(blocks) }
    end
  end
end
