# frozen_string_literal: true

RSpec.describe Slkecho do
  describe "execute" do
    subject do
      system "exe/slkecho #{args}"
    end

    context "with --help" do
      let(:args) { "--help" }

      it { expect { subject }.to output(/Usage: slkecho/).to_stdout_from_any_process }
    end

    context "with --version" do
      let(:args) { "--version" }

      it { expect { subject }.to output(/#{Slkecho::VERSION}/).to_stdout_from_any_process }
    end

    context "when --channel is missing" do
      let(:args) { "message" }

      it { expect { subject }.to output(/channel is required./).to_stderr_from_any_process }
    end

    context "when --channel is invalid" do
      let(:args) { "--channel 'invalid'" }

      it { expect { subject }.to output(/channel must start with # or C./).to_stderr_from_any_process }
    end

    context "when message is missing" do
      let(:args) { "--channel '#general'" }

      it { expect { subject }.to output(/message is missing./).to_stderr_from_any_process }
    end
  end
end
