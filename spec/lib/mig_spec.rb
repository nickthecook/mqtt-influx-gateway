# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mig do
  subject { described_class.new(config_path: "spec/fixtures/files/config.yml") }

  include_context "silenced logger"

  describe "#mqtt_receive" do
    let(:result) { subject.mqtt_receive(topic, msg, msg_hash) }
    let(:topic) { "/test/topic" }
    let(:msg_hash) { { "key1" => "value 1" } }
    let(:msg) { msg_hash.to_json }
    let(:expected_tags) { { topic: "/test/topic", client_id: "mig_test_0" } }

    before do
      allow(StatsD).to receive(:increment)
    end

    shared_examples "increments counter" do
      it "increments the configured statsd counter" do
        expect(StatsD).to receive(:increment).with("test.mqtt.messages", tags: expected_tags)
        result
      end
    end

    include_examples "increments counter"

    context "when msg_hash is nil" do
      let(:msg_hash) { nil }
      let(:msg) { "some non-JSON string" }

      include_examples "increments counter"
    end
  end
end
