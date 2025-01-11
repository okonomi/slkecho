# frozen_string_literal: true

RSpec.describe Slkecho::Command::ConfigureUserToken do
  describe "#execute" do
    subject { described_class.new.execute }

    its_block { is_expected.to output("Slkecho configuration\n").to_stdout }
  end
end
