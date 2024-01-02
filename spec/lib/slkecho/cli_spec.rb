# frozen_string_literal: true

RSpec.describe Slkecho::CLI do
  describe ".parse_options" do
    subject { described_class.parse_options(argv) }

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
end
