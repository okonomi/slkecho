# frozen_string_literal: true

RSpec.describe Slkecho::SlackRequest::PostMessage do
  let(:slack_api_token) { "xoxb-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx" }

  describe "#request" do
    subject do
      described_class.new(slack_api_token: slack_api_token)
                     .request(
                       Slkecho::SlackRequest::PostMessage::Params.new(channel: "#general", blocks: blocks)
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

    before do
      stub_request(:post, "https://slack.com/api/chat.postMessage")
        .to_return(status: [status_code, status_message], body: response_body)
    end

    context "when API request is successful" do
      let(:status_code) { 200 }
      let(:status_message) { "OK" }
      let(:response_body) { { ok: true }.to_json }

      it { is_expected.to be_truthy }
    end

    context "when API request is not successful" do
      let(:status_code) { 200 }
      let(:status_message) { "OK" }
      let(:response_body) { { ok: false, error: "too_many_attachments" }.to_json }

      its_block { is_expected.to raise_error(Slkecho::SlackApiResultError, "too_many_attachments") }
    end

    context "when HTTP error respond" do
      let(:status_code) { 400 }
      let(:status_message) { "Bad Request" }
      let(:response_body) { "" }

      its_block { is_expected.to raise_error(Slkecho::SlackApiHttpError, "400 Bad Request") }
    end
  end
end
