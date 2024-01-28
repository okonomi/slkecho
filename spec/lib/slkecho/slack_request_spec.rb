# frozen_string_literal: true

RSpec.describe Slkecho::SlackRequest do
  describe ".send_request" do
    subject do
      described_class.send_request(&block)
    end

    context "when block is not given" do
      let(:block) { nil }

      it { is_expected.to be_nil }
    end

    context "when block is not response return" do
      let(:block) do
        proc do
          "response"
        end
      end

      it { expect { subject }.to raise_error(Slkecho::SlackApiError, "API Response could not be retrieved.") }
    end

    context "when response is not success" do
      let(:block) do
        proc do
          response = instance_double(Net::HTTPBadRequest, code: 400, message: "Bad Request", body: "")
          allow(response).to receive(:is_a?).with(Net::HTTPResponse).and_return(true)
          allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
          response
        end
      end

      it { expect { subject }.to raise_error(Slkecho::SlackApiHttpError, "400 Bad Request") }
    end

    context "when response is not JSON" do
      let(:block) do
        proc do
          response = instance_double(Net::HTTPSuccess, body: "invalid")
          allow(response).to receive(:is_a?).with(Net::HTTPResponse).and_return(true)
          allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
          response
        end
      end

      it { expect { subject }.to raise_error(Slkecho::SlackApiError, "API Response is not JSON.") }
    end

    context "when response is valid" do
      let(:block) do
        proc do
          response = instance_double(Net::HTTPSuccess, body: { ok: true }.to_json)
          allow(response).to receive(:is_a?).with(Net::HTTPResponse).and_return(true)
          allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
          response
        end
      end

      it { is_expected.to eq({ ok: true }) }
    end
  end
end
