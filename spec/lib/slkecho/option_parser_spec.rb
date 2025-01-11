# frozen_string_literal: true

require "fakefs/safe"

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

    context "when token is given" do
      let(:argv) { %w[--token token] }

      it { is_expected.to have_attributes(token: "token") }
    end

    context "when configure is given" do
      let(:argv) { %w[--configure] }

      it { is_expected.to have_attributes(configure: true) }
    end
  end

  describe "#fetch_token" do
    subject { described_class.new.fetch_token(option_values) }

    context "when token is given" do
      let(:option_values) { { token: "token" } }

      it { is_expected.to eq "token" }
    end

    context "when SLACK_API_TOKEN is set" do
      let(:option_values) { {} }

      around do |example|
        ClimateControl.modify SLACK_API_TOKEN: "token" do
          example.run
        end
      end

      it { is_expected.to eq "token" }
    end

    context "when token is not given" do
      let(:option_values) { {} }

      around do |example|
        FakeFS.with_fresh do
          example.run
        end
      end

      before do
        config_path = Pathname.new(File.expand_path("~/.config/slkecho/token.json"))
        config_path.dirname.mkpath
        config = { authed_user: { access_token: "token" } }
        File.write(config_path, JSON.generate(config))
      end

      it { is_expected.to eq "token" }
    end
  end

  describe "#validate_options" do
    subject { described_class.new.validate_options(options) }

    context "when options is valid" do
      let(:options) { instance_double(Slkecho::Options, valid?: true, error_message: "") }

      it { is_expected.to be_truthy }
    end

    context "when options is invalid" do
      let(:options) { instance_double(Slkecho::Options, valid?: false, error_message: "error") }

      its_block { is_expected.to raise_error(Slkecho::InvalidOptionError, "error") }
    end
  end
end
