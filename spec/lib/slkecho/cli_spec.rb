# frozen_string_literal: true

RSpec.describe Slkecho::CLI do
  describe "#mention_to_user_id" do
    subject do
      described_class.new(option_parser: option_parser, slack_client: slack_client)
                     .mention_to_user_id(mention)
    end

    let(:option_parser) { instance_double(Slkecho::OptionParser) }
    let(:slack_client) { instance_double(Slkecho::SlackClient) }

    context "when mention is nil" do
      let(:mention) { nil }

      it { is_expected.to be_nil }
    end

    context "when mention is user id" do
      let(:mention) { "U012A3CDE" }

      it { is_expected.to eq("U012A3CDE") }
    end

    context "when mention is email" do
      let(:mention) { "user1@example.com" }
      let(:slack_client) { instance_double(Slkecho::SlackClient, lookup_user_by_email: user) }
      let(:user) { { "id" => "U012A3CDE" } }

      it { is_expected.to eq("U012A3CDE") }
    end
  end
end
