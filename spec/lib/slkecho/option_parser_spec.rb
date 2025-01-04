# frozen_string_literal: true

RSpec.describe Slkecho::OptionParser do
  describe "#build_options" do
    subject { described_class.new.build_options(argv) }

    context "when no arguments" do
      let(:argv) { %w[] }

      it { is_expected.to have_attributes(channel: nil, mention_by_email: nil, message: nil) }
    end

    context "when channel option is given" do
      let(:argv) { %w[-c #general] }

      it { is_expected.to have_attributes(channel: "#general", mention_by_email: nil, message: nil) }
    end

    context "when channel and message option is given" do
      let(:argv) { %w[-c #general message] }

      it { is_expected.to have_attributes(channel: "#general", mention_by_email: nil, message: "message") }
    end

    context "when channel and message and to option is given" do
      let(:argv) { %w[-c #general -m user1@example.com message] }

      it {
        expect(subject).to have_attributes(channel: "#general", mention_by_email: "user1@example.com",
                                           message: "message")
      }
    end

    context "when message is from stdin" do
      let(:argv) { %w[-c #general] }
      let(:stdin) { instance_double(IO, tty?: false, read: "message") }

      before { $stdin = stdin }
      after { $stdin = STDIN }

      it { is_expected.to have_attributes(channel: "#general", mention_by_email: nil, message: "message") }
    end

    context "when message is nothing" do
      let(:argv) { %w[] }
      let(:stdin) { instance_double(IO, tty?: false, read: "") }

      before { $stdin = stdin }
      after { $stdin = STDIN }

      it { is_expected.to have_attributes(message: nil) }
    end

    context "when username is given" do
      let(:argv) { ["--username", "My Bot"] }

      it { is_expected.to have_attributes(username: "My Bot") }
    end

    context "when icon-url is given" do
      let(:argv) { %w[--icon-url https://example.com/icon.png] }

      it { is_expected.to have_attributes(icon_url: "https://example.com/icon.png") }
    end

    context "when icon-emoji is given" do
      let(:argv) { %w[--icon-emoji :smile:] }

      it { is_expected.to have_attributes(icon_emoji: ":smile:") }
    end

    context "when message-as-blocks is given" do
      let(:argv) { %w[--message-as-blocks] }

      it { is_expected.to have_attributes(message_as_blocks: true) }
    end
  end

  describe "#validate_options" do
    def options_from(values)
      Slkecho::Options.new.tap do |opt|
        values.each { |k, v| opt.send(:"#{k}=", v) }
      end
    end

    subject { described_class.new.validate_options(options_from(option_values)) }

    context "when channel is not given" do
      let(:option_values) { { channel: nil, message: "" } }

      its_block { is_expected.to raise_error(Slkecho::InvalidOptionError, "channel is required.") }
    end

    context "when channel starts with #" do
      let(:option_values) { { channel: "#general", message: "" } }

      it { is_expected.to be_truthy }
    end

    context "when channel starts with C" do
      let(:option_values) { { channel: "C123ABC456", message: "" } }

      it { is_expected.to be_truthy }
    end

    context "when message is not given" do
      let(:option_values) { { channel: "#general", message: nil } }

      its_block { is_expected.to raise_error(Slkecho::InvalidOptionError, "message is missing.") }
    end
  end
end
