# frozen_string_literal: true

RSpec.describe Slkecho::Configuration do
  describe "#initialize" do
    subject do
      c = described_class.new
      c.slack_api_token = slack_api_token
      c
    end

    context "when no options are passed" do
      let(:slack_api_token) { nil }

      it { is_expected.to have_attributes(slack_api_token: nil) }
    end

    context "when options are passed" do
      let(:slack_api_token) { "xoxb-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx" }

      it { is_expected.to have_attributes(slack_api_token: slack_api_token) }
    end
  end

  describe "#validate" do
    subject do
      c = described_class.new
      c.slack_api_token = slack_api_token
      c.validate
    end

    context "when slack_api_token is not given" do
      let(:slack_api_token) { nil }

      its_block { is_expected.to raise_error(Slkecho::InvalidConfigurationError, "slack_api_token is required.") }
    end
  end
end
