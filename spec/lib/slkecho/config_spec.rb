# frozen_string_literal: true

require "fakefs/safe"

RSpec.describe Slkecho::Config do
  let(:token_info) do
    {
      "app_id" => "A123456",
      "authed_user" => {
        "id" => "U123456",
        "access_token" => "xoxp-123456"
      },
      "team" => {
        "id" => "T123456",
        "name" => "Test Team"
      }
    }
  end

  let(:config_data) do
    {
      "token_info" => [token_info]
    }
  end

  describe ".config_dir" do
    subject { described_class.config_dir }

    context "when XDG_CONFIG_HOME is set" do
      around do |example|
        ClimateControl.modify XDG_CONFIG_HOME: "/custom/config/path" do
          example.run
        end
      end

      it { is_expected.to eq Pathname.new("/custom/config/path") }
    end

    context "when XDG_CONFIG_HOME is not set" do
      around do |example|
        ClimateControl.modify XDG_CONFIG_HOME: nil, HOME: "/home/user" do
          example.run
        end
      end

      it { is_expected.to eq Pathname.new("/home/user/.config") }
    end
  end

  describe ".config_path" do
    subject { described_class.config_path }

    around do |example|
      ClimateControl.modify XDG_CONFIG_HOME: "/custom/config" do
        example.run
      end
    end

    it { is_expected.to eq Pathname.new("/custom/config/slkecho/token.json") }
  end

  describe ".save" do
    subject { described_class.save(token_info) }

    around do |example|
      ClimateControl.modify XDG_CONFIG_HOME: "/custom/config" do
        FakeFS.with_fresh do
          example.run
        end
      end
    end

    its_block { is_expected.to change { described_class.config_path.dirname.exist? }.from(false).to(true) }
  end

  describe ".load" do
    subject { described_class.load }

    around do |example|
      ClimateControl.modify XDG_CONFIG_HOME: "/custom/config" do
        FakeFS.with_fresh do
          example.run
        end
      end
    end

    context "when config file exists" do
      before do
        FileUtils.mkdir_p(described_class.config_path.dirname)
        File.write(described_class.config_path, JSON.pretty_generate(config_data))
      end

      it { is_expected.to eq token_info }
    end

    context "when config file doesn't exist" do
      it { is_expected.to be_nil }
    end
  end
end
