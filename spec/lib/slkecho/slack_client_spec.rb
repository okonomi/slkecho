# frozen_string_literal: true

RSpec.describe Slkecho::SlackClient do
  let(:slack_api_token) { "xoxb-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx" }

  describe "#post_message" do
    subject { described_class.new(slack_api_token: slack_api_token).post_message(options) }

    let(:options) do
      Slkecho::Options.new(
        channel: "#general",
        subject: "subject",
        message: "message"
      )
    end

    before do
      stub_request(:post, "https://slack.com/api/chat.postMessage")
        .to_return(status: 200, body: { ok: true }.to_json)
    end

    it "sends HTTP request" do
      subject
      expect(WebMock).to have_requested(:post, "https://slack.com/api/chat.postMessage")
    end
  end

  describe "#request_body" do
    subject do
      described_class.new(slack_api_token: slack_api_token)
                     .request_body(channel: options.channel, message: options.message, subject: options.subject)
    end

    context "when subject is given" do
      let(:options) do
        Slkecho::Options.new(
          channel: "#general",
          subject: "subject",
          message: "message"
        )
      end

      let(:blocks) do
        [
          {
            "type" => "header",
            "text" => {
              "type" => "plain_text",
              "text" => "subject",
              "emoji" => true
            }
          },
          {
            "type" => "section",
            "text" => {
              "type" => "mrkdwn",
              "text" => "message"
            }
          }
        ]
      end

      it { is_expected.to include("blocks" => blocks) }
    end

    context "when subject is not given" do
      let(:options) do
        Slkecho::Options.new(
          channel: "#general",
          subject: nil,
          message: "message"
        )
      end

      let(:blocks) do
        [
          {
            "type" => "section",
            "text" => {
              "type" => "mrkdwn",
              "text" => "message"
            }
          }
        ]
      end

      it { is_expected.to include("blocks" => blocks) }
    end
  end
end
