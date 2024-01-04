# frozen_string_literal: true

RSpec.describe Slkecho::SlackRequest::PostMessage do
  let(:slack_api_token) { "xoxb-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx" }

  describe "#request" do
    subject do
      described_class.new(slack_api_token: slack_api_token)
                     .request(channel: channel, message: message, subject: subject_)
    end

    let(:channel) { "#general" }
    let(:message) { "message" }
    let(:subject_) { "subject" }

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
                     .request_body(channel: channel, message: message, subject: subject_)
    end

    context "when subject is given" do
      let(:channel) { "#general" }
      let(:message) { "message" }
      let(:subject_) { "subject" }
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
      let(:channel) { "#general" }
      let(:message) { "message" }
      let(:subject_) { nil }
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
