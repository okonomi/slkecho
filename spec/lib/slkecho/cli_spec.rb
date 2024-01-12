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

  describe "#post_message_params_from" do
    subject do
      described_class.new(option_parser: option_parser, slack_client: slack_client)
                     .post_message_params_from(options, user_id)
    end

    let(:option_parser) { instance_double(Slkecho::OptionParser) }
    let(:slack_client) { instance_double(Slkecho::SlackClient) }

    context "when valid options" do
      let(:options) do
        Slkecho::Options.new.tap do
          _1.channel = "#general"
          _1.mention_by_email = "user1@example.com"
          _1.message = "message"
          _1.username = "My Bot"
          _1.icon_url = "https://example.com/icon.png"
          _1.icon_emoji = ":smile:"
        end
      end
      let(:user_id) { "U012A3CDE" }
      let(:params) do
        Slkecho::SlackClient::PostMessageParams.new(
          channel: "#general",
          message: "<@U012A3CDE> message",
          username: "My Bot",
          icon_url: "https://example.com/icon.png",
          icon_emoji: ":smile:"
        )
      end

      it { is_expected.to eq(params) }
    end
  end
end
