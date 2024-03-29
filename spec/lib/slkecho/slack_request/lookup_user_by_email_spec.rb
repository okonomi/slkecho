# frozen_string_literal: true

RSpec.describe Slkecho::SlackRequest::LookupUserByEmail do
  let(:slack_api_token) { "xoxb-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx" }

  describe "#request" do
    subject { described_class.new(slack_api_token: slack_api_token).request(email: email) }

    before do
      stub_request(:get, "https://slack.com/api/users.lookupByEmail?#{URI.encode_www_form({ email: email })}")
        .to_return(status: [status_code, status_message], body: response_body)
    end

    let(:email) { "user1@example.com" }
    let(:status_code) { 200 }
    let(:status_message) { "OK" }

    context "when user is found" do
      let(:response_body) { { ok: true, user: { id: "W012A3CDE" } }.to_json }

      it { is_expected.to include(id: "W012A3CDE") }
    end

    context "when user is not found" do
      let(:response_body) { { ok: false, error: "users_not_found" }.to_json }

      its_block { is_expected.to raise_error(Slkecho::SlackApiResultError, "user not found. (#{email})") }
    end

    context "when some error responsed" do
      let(:response_body) { { ok: false, error: "some_error" }.to_json }

      its_block { is_expected.to raise_error(Slkecho::SlackApiResultError, "some_error") }
    end

    context "when HTTP error respond" do
      let(:status_code) { 400 }
      let(:status_message) { "Bad Request" }
      let(:response_body) { "" }

      its_block { is_expected.to raise_error(Slkecho::SlackApiHttpError, "400 Bad Request") }
    end
  end
end
