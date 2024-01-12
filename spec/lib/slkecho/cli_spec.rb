# frozen_string_literal: true

RSpec.describe Slkecho::CLI do
  describe "#email_to_user_id" do
    subject do
      described_class.new(option_parser: option_parser, slack_client: slack_client)
                     .email_to_user_id(email)
    end

    let(:option_parser) { instance_double(Slkecho::OptionParser) }

    context "when email is member" do
      let(:email) { "user1@example.com" }
      let(:slack_client) { instance_double(Slkecho::SlackClient, lookup_user_by_email: user) }
      let(:user) { { "id" => "U012A3CDE" } }

      it { is_expected.to eq("U012A3CDE") }
    end

    context "when email is not member" do
      let(:email) { "notmember@example.com" }
      let(:slack_client) do
        client = instance_double(Slkecho::SlackClient)
        allow(client).to receive(:lookup_user_by_email).and_raise(Slkecho::SlackResponseError,
                                                                  "user not found. (#{email})")

        client
      end

      it "raises SlackResponseError" do
        expect { subject }.to raise_error(Slkecho::SlackResponseError, "user not found. (#{email})")
      end
    end
  end
end
