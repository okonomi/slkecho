# frozen_string_literal: true

RSpec.describe Slkecho::Options do
  describe "#validate" do
    subject do
      described_class.new(values).validate
    end

    context "when values is not given" do
      let(:values) { {} }

      it { is_expected.to be_falsey }
    end

    context "when message is blank" do
      let(:values) { { channel: "foo", message: "" } }

      it { is_expected.to be_truthy }
    end

    context "when message is nil" do
      let(:values) { { channel: "foo", message: nil } }

      it { is_expected.to be_falsey }
    end

    context "when token is given" do
      let(:values) { { channel: "foo", message: "bar", token: "xxx" } }

      it { is_expected.to be_truthy }
    end

    context "when configure is true" do
      let(:values) { { configure: true } }

      it { is_expected.to be_truthy }
    end
  end

  describe "#error_message" do
    subject do
      opt = described_class.new(option_values)
      opt.validate
      opt.error_message
    end

    context "when there is no error" do
      let(:option_values) { { channel: "foo", message: "bar" } }

      it { is_expected.to eq "" }
    end

    context "when there is an error" do
      let(:option_values) { { channel: nil, message: "bar" } }

      it { is_expected.to eq "channel is required." }
    end
  end
end
