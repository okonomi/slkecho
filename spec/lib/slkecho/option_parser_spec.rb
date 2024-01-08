# frozen_string_literal: true

RSpec.describe Slkecho::OptionParser do
  describe "#parse_options" do
    subject { described_class.new.parse_options(argv) }

    context "when no arguments" do
      let(:argv) { %w[] }

      it { is_expected.to have_attributes(channel: nil, subject: nil, mention: nil, message: nil) }
    end

    context "when channel option is given" do
      let(:argv) { %w[-c #general] }

      it { is_expected.to have_attributes(channel: "#general", subject: nil, mention: nil, message: nil) }
    end

    context "when channel and subject option is given" do
      let(:argv) { %w[-c #general -s subject] }

      it { is_expected.to have_attributes(channel: "#general", subject: "subject", mention: nil, message: nil) }
    end

    context "when channel and subject and message option is given" do
      let(:argv) { %w[-c #general -s subject message] }

      it { is_expected.to have_attributes(channel: "#general", subject: "subject", mention: nil, message: "message") }
    end

    context "when channel and subject and message and to option is given" do
      let(:argv) { %w[-c #general -s subject -m user1@example.com message] }

      it {
        expect(subject).to have_attributes(channel: "#general", subject: "subject", mention: "user1@example.com",
                                           message: "message")
      }
    end

    context "when message is from stdin" do
      let(:argv) { %w[-c #general] }
      let(:stdin) { instance_double(IO, tty?: false, read: "message") }
      let!(:orig_stdin) { $stdin }

      before { $stdin = stdin }
      after { $stdin = orig_stdin }

      it { is_expected.to have_attributes(channel: "#general", subject: nil, mention: nil, message: "message") }
    end
  end

  describe "#validate_options" do
    subject { described_class.new.validate_options(options) }

    context "when channel is not given" do
      let(:options) { Slkecho::Options.new(channel: nil, message: "") }

      it "raises InvalidOptionError" do
        expect { subject }.to raise_error(Slkecho::InvalidOptionError, "channel is required.")
      end
    end

    context "when channel does not start with # or C" do
      let(:options) { Slkecho::Options.new(channel: "general", message: "") }

      it "raises InvalidOptionError" do
        expect { subject }.to raise_error(Slkecho::InvalidOptionError, "channel must start with # or C.")
      end
    end

    context "when channel starts with #" do
      let(:options) { Slkecho::Options.new(channel: "#general", message: "") }

      it { is_expected.to be_truthy }
    end

    context "when channel starts with C" do
      let(:options) { Slkecho::Options.new(channel: "C123ABC456", message: "") }

      it { is_expected.to be_truthy }
    end

    context "when subject is not given" do
      let(:options) { Slkecho::Options.new(channel: "#general", subject: nil, message: "") }

      it { is_expected.to be_truthy }
    end

    context "when subject is given" do
      let(:options) { Slkecho::Options.new(channel: "#general", subject: "subject", message: "") }

      it { is_expected.to be_truthy }
    end

    context "when message is not given" do
      let(:options) { Slkecho::Options.new(channel: "#general", message: nil) }

      it "raises InvalidOptionError" do
        expect { subject }.to raise_error(Slkecho::InvalidOptionError, "message is missing.")
      end
    end
  end
end
