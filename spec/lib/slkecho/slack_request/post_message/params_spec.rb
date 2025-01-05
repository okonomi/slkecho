# frozen_string_literal: true

RSpec.describe Slkecho::SlackRequest::PostMessage::Params do
  describe "#to_request_body" do
    subject do
      described_class.new(**values).to_request_body
    end

    context "when all values are nil" do
      let(:values) { {} }

      it {
        expect(subject).to be_json_sym({ channel: nil, blocks: nil,
                                         username: nil, icon_url: nil, icon_emoji: nil })
      }
    end

    context "when all values are given" do
      let(:values) do
        {
          channel: "#general",
          blocks: [{ "type" => "section", "text" => { "type" => "mrkdwn", "text" => "message" } }],
          username: "My Bot",
          icon_url: "https://example.com/icon.png",
          icon_emoji: ":smile:"
        }
      end

      it do # rubocop:disable RSpec/ExampleLength
        expect(subject).to be_json_sym(
          {
            channel: "#general",
            blocks: [{ type: "section", text: { type: "mrkdwn", text: "message" } }],
            username: "My Bot",
            icon_url: "https://example.com/icon.png",
            icon_emoji: ":smile:"
          }
        )
      end
    end
  end
end
