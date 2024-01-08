# frozen_string_literal: true

RSpec.describe Slkecho::SlackRequest::PostMessage do
  let(:slack_api_token) { "xoxb-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx" }

  describe "#request" do
    subject do
      described_class.new(slack_api_token: slack_api_token)
                     .request(channel: "#general", message: "message", subject: "subject")
    end

    before do
      stub_request(:post, "https://slack.com/api/chat.postMessage")
        .to_return(status: status_code, body: response_body)
    end

    context "when API request is successful" do
      let(:status_code) { 200 }
      let(:response_body) { { ok: true }.to_json }

      it { is_expected.to be_truthy }
    end

    context "when API request is not successful" do
      let(:status_code) { 200 }
      let(:response_body) { { ok: false, "error": "too_many_attachments" }.to_json }

      it "raises SlackResponseError" do
        expect { subject }.to raise_error(Slkecho::SlackResponseError, "too_many_attachments")
      end
    end

    context "when HTTP error respond" do
      let(:status_code) { 400 }
      let(:response_body) { "Bad Request" }

      it "raises SlackRequestError" do
        expect { subject }.to raise_error(Slkecho::SlackRequestError, "Bad Request")
      end
    end
  end

  describe "#request_body" do
    subject do
      described_class.new(slack_api_token: slack_api_token)
                     .request_body(**params)
    end

    context "when subject is given" do
      let(:params) { { channel: "#general", message: "message", subject: "subject" } }
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
      let(:params) { { channel: "#general", message: "message" } }
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

    context "when username is given" do
      let(:params) { { channel: "#general", message: "message", username: "My Bot" } }

      it { is_expected.to include("username" => "My Bot") }
    end

    context "when icon_url is given" do
      let(:params) { { channel: "#general", message: "message", icon_url: "https://example.com/icon.png" } }

      it { is_expected.to include("icon_url" => "https://example.com/icon.png") }
    end
  end
end
