# frozen_string_literal: true

RSpec.describe Slkecho::SlackClient do
  describe "#post_message" do
    subject { described_class.new.post_message(options) }

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
end
