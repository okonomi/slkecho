# frozen_string_literal: true

RSpec.describe Slkecho do
  describe "execute" do
    subject do
      system({ "SLACK_API_TOKEN" => nil, "XDG_CONFIG_HOME" => "/tmp/.config" }, "exe/slkecho #{args}")
    end

    context "with --help" do
      let(:args) { "--help" }

      its_block { is_expected.to output(/Usage: slkecho/).to_stdout_from_any_process }
    end

    context "with --version" do
      let(:args) { "--version" }

      its_block { is_expected.to output(/#{Slkecho::VERSION}/o).to_stdout_from_any_process }
    end

    context "when --channel is missing" do
      let(:args) { "message" }

      its_block { is_expected.to output(/channel is required./).to_stderr_from_any_process }
    end

    context "when message is missing" do
      let(:args) { "--channel '#general'" }

      its_block { is_expected.to output(/message is missing./).to_stderr_from_any_process }
    end

    context "when slack api token is missing" do
      let(:args) { "--channel '#general' message" }

      its_block { is_expected.to output(/token is required./).to_stderr_from_any_process }
    end
  end
end
