# frozen_string_literal: true

RSpec.describe Slkecho::CLI do
  describe "#email_to_user_id" do
    subject do
      described_class.new(
        option_parser: instance_double(Slkecho::OptionParser),
        slack_client: slack_client,
        blocks_builder: instance_double(Slkecho::BlocksBuilder)
      ).email_to_user_id(email)
    end

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
        allow(client).to receive(:lookup_user_by_email).and_raise(Slkecho::SlackApiResultError,
                                                                  "user not found. (#{email})")
        client
      end

      it "raises SlackApiResultError" do
        expect { subject }.to raise_error(Slkecho::SlackApiResultError, "user not found. (#{email})")
      end
    end
  end

  describe "#post_message_params_from" do
    subject do
      described_class.new(
        option_parser: instance_double(Slkecho::OptionParser),
        slack_client: instance_double(Slkecho::SlackClient),
        blocks_builder: blocks_builder
      ).post_message_params_from(options, user_id)
    end

    context "when valid options" do
      let(:blocks_builder) do
        instance_double(Slkecho::BlocksBuilder, build_from_message: [
                          {
                            "type" => "section",
                            "text" => {
                              "type" => "mrkdwn",
                              "text" => "<@#{user_id}> message"
                            }
                          }
                        ])
      end
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
          blocks: [
            {
              "type" => "section",
              "text" => {
                "type" => "mrkdwn",
                "text" => "<@#{user_id}> message"
              }
            }
          ],
          username: "My Bot",
          icon_url: "https://example.com/icon.png",
          icon_emoji: ":smile:"
        )
      end

      it { is_expected.to eq(params) }
    end

    context "when blocks is given" do
      let(:blocks_builder) do
        instance_double(Slkecho::BlocksBuilder, build_from_json: [
                          {
                            "type" => "section",
                            "text" => {
                              "type" => "mrkdwn",
                              "text" => "<@#{user_id}> message"
                            }
                          }
                        ])
      end
      let(:options) do
        Slkecho::Options.new.tap do
          _1.channel = "#general"
          _1.mention_by_email = "user1@example.com"
          _1.message = <<~BLOCKS
            [
              {
                "type": "section",
                "text": {
                  "type": "mrkdwn",
                  "text": "<mention> message"
                }
              }
            ]
          BLOCKS
          _1.username = "My Bot"
          _1.icon_url = "https://example.com/icon.png"
          _1.icon_emoji = ":smile:"
          _1.message_as_blocks = true
        end
      end
      let(:user_id) { "U012A3CDE" }
      let(:params) do
        Slkecho::SlackClient::PostMessageParams.new(
          channel: "#general",
          blocks: [
            {
              "type" => "section",
              "text" => {
                "type" => "mrkdwn",
                "text" => "<@#{user_id}> message"
              }
            }
          ],
          username: "My Bot",
          icon_url: "https://example.com/icon.png",
          icon_emoji: ":smile:"
        )
      end

      it { is_expected.to eq(params) }
    end
  end
end
