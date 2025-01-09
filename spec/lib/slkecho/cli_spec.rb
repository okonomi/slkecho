# frozen_string_literal: true

RSpec.describe Slkecho::CLI do
  describe "#run" do
    subject do
      described_class.new(
        option_parser: Slkecho::OptionParser.new,
        blocks_builder: Slkecho::BlocksBuilder.new
      ).run(argv)
    end

    context "when configure is true" do
      let(:argv) { %w[--configure] }

      its_block { is_expected.to output("Slkecho configuration\n").to_stdout }
    end

    context "when post message" do
      let(:argv) { %w[--channel #general --token token message] }

      before do
        slack_client = instance_double(Slkecho::SlackClient)
        allow(Slkecho::SlackClient).to receive(:new).with(slack_api_token: "token").and_return(slack_client)
        allow(slack_client).to receive(:post_message).and_return(nil)
      end

      its_block { is_expected.to output("Message sent successfully.\n").to_stdout }
    end

    context "when token is given by environment variable" do
      let(:argv) { %w[--channel #general message] }

      before do
        slack_client = instance_double(Slkecho::SlackClient)
        allow(Slkecho::SlackClient).to receive(:new).with(slack_api_token: "token").and_return(slack_client)
        allow(slack_client).to receive(:post_message).and_return(nil)
      end

      around do |example|
        ClimateControl.modify SLACK_API_TOKEN: "token" do
          example.run
        end
      end

      its_block { is_expected.to output("Message sent successfully.\n").to_stdout }
    end
  end
end
