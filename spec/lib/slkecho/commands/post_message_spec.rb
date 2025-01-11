# frozen_string_literal: true

RSpec.describe Slkecho::Commands::PostMessage do
  describe "#execute" do
    subject do
      described_class.new(
        blocks_builder: Slkecho::BlocksBuilder.new,
        options: Slkecho::Options.new(token: "token")
      ).execute
    end

    before do
      slack_client = instance_double(Slkecho::SlackClient)
      allow(Slkecho::SlackClient).to receive(:new).with(slack_api_token: "token").and_return(slack_client)
      allow(slack_client).to receive(:post_message).and_return(nil)
    end

    its_block { is_expected.to output("Message sent successfully.\n").to_stdout }
  end
end
