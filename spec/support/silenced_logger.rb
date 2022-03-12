# frozen_string_literal: true

RSpec.shared_context "silenced logger" do
  before do
    class MqttService
      def puts(*_); end
    end
  end
end
