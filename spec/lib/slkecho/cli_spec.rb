# frozen_string_literal: true

RSpec.describe Slkecho::CLI do
  describe "#parse_options" do
    subject { described_class.new.parse_options(argv) }

    context "when no arguments" do
      let(:argv) { %w[] }

      it { is_expected.to eq(Slkecho::CLI::Options.new) }
    end

    context "when channel option is given" do
      let(:argv) { %w[-c #general] }

      it { is_expected.to eq(Slkecho::CLI::Options.new(channel: "#general")) }
    end

    context "when channel and subject option is given" do
      let(:argv) { %w[-c #general -s subject] }

      it { is_expected.to eq(Slkecho::CLI::Options.new(channel: "#general", subject: "subject")) }
    end
  end

  describe "#validate_options" do
    subject { described_class.new.validate_options(options) }

    context "when channel is not given" do
      let(:options) { { channel: nil, message: "" } }

      it "raises InvalidOptionError" do
        expect { subject }.to raise_error(Slkecho::InvalidOptionError, "channel is required.")
      end
    end

    context "when channel does not start with #" do
      let(:options) { { channel: "general", message: "" } }

      it "raises InvalidOptionError" do
        expect { subject }.to raise_error(Slkecho::InvalidOptionError, "channel must start with #.")
      end
    end

    context "when channel starts with #" do
      let(:options) { { channel: "#general", message: "" } }

      it { is_expected.to be_truthy }
    end

    context "when subject is not given" do
      let(:options) { { channel: "#general", subject: nil, message: "" } }

      it { is_expected.to be_truthy }
    end

    context "when subject is given" do
      let(:options) { { channel: "#general", subject: "subject", message: "" } }

      it { is_expected.to be_truthy }
    end

    context "when subject is empty" do
      let(:options) { { channel: "#general", subject: "", message: "" } }

      it { is_expected.to be_truthy }
    end

    context "when message is not given" do
      let(:options) { { channel: "#general", subject: "subject", message: nil } }

      it "raises InvalidOptionError" do
        expect { subject }.to raise_error(Slkecho::InvalidOptionError, "message is missing.")
      end
    end
  end
end
