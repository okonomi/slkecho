# frozen_string_literal: true

RSpec.describe Slkecho::CLI do
  describe "#run" do
    subject do
      described_class.new(
        option_parser: Slkecho::OptionParser.new
      ).run(argv)
    end

    context "when configure is true" do
      let(:argv) { %w[--configure] }

      its_block { is_expected.to output("Slkecho configuration\n").to_stdout }
    end

    context "when post message" do
      let(:argv) { %w[--channel #general --token token message] }

      before do
        post_message_command = instance_double(Slkecho::Command::PostMessage)
        allow(Slkecho::Command::PostMessage).to receive(:new).and_return(post_message_command)
        allow(post_message_command).to receive(:execute) { puts "Message sent successfully.\n" }
      end

      its_block { is_expected.to output("Message sent successfully.\n").to_stdout }
    end

    context "when token is given by environment variable" do
      let(:argv) { %w[--channel #general message] }

      before do
        post_message_command = instance_double(Slkecho::Command::PostMessage)
        allow(Slkecho::Command::PostMessage).to receive(:new).and_return(post_message_command)
        allow(post_message_command).to receive(:execute) { puts "Message sent successfully.\n" }
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
