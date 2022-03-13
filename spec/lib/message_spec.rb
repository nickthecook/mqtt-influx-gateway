# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Message do
  subject { described_class.new(topic, body) }

  let(:topic) { "/test/topic" }
  let(:body) { { "key" => "value", "clientid" => "test_client" }}

  describe ".from_string" do
    let(:result) { described_class.from_string(topic, body) }
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

    it "has the correct tags" do
      expect(result.tags).to eq({ topic: "/test/topic", client_id: "unknown" })
    end
  end

  describe ".tags" do
    let(:result) { subject.tags }

    it "returns the correct tags" do
      expect(result).to eq({ topic: "/test/topic", client_id: "test_client"} )
    end
  end
end
