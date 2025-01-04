# frozen_string_literal: true

RSpec.describe Slkecho::Options do
  describe "#validate" do
    subject do
      described_class.new.tap do |o|
        values.each { |k, v| o.send(:"#{k}=", v) }
      end.validate
    end

    context "when values is not given" do
      let(:values) { {} }

      it { is_expected.to include("channel is required.") }
      it { is_expected.to include("message is missing.") }
    end
  end
end
