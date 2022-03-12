# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Message do
  describe ".from_string" do
    let(:result) { described_class.from_string(client_id, topic, body) }
    let(:client_id) { "mig_test_0" }
    let(:topic) { "/test/topic" }
    let(:body) { "non-JSON body string" }

    it "returns a Message" do
      expect(result).to be_a(Message)
    end

    it "has the correct topic" do
      expect(result.topic).to eq("/test/topic")
    end

    it "has the correct body" do
      expect(result.body).to eq({ "_msg" => "non-JSON body string" })
    end
  end
end
