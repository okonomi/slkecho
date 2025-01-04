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
  end
end
