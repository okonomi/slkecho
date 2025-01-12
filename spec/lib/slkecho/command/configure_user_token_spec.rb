# frozen_string_literal: true

require "fakefs/safe"

RSpec.describe Slkecho::Command::ConfigureUserToken do
  describe "#execute" do
    subject { described_class.new.execute }

    context "when inputs is correct" do
      around do |example|
        FakeFS.with_fresh do
          example.run
        end
      end

      before do
        $stdin = StringIO.new(<<~INPUT)
          client_id
          client_secret
          code
        INPUT

        allow(Launchy).to receive(:open).and_return(nil)

        stub_request(:post, "https://slack.com/api/oauth.v2.access")
          .to_return(status: 200, body: { ok: true, authed_user: { access_token: "token" } }.to_json)
      end

      after do
        $stdin = STDIN
      end

      its_block { is_expected.to output(/Slkecho configuration\n/).to_stdout }
    end
  end
end
