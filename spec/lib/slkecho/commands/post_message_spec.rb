# frozen_string_literal: true

RSpec.describe Slkecho::Commands::PostMessage do
  describe "#execute" do
    subject { described_class.new.execute }

    its_block { is_expected.to output("Message sent successfully.\n").to_stdout }
  end
end
