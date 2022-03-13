# frozen_string_literal: true

class Message
  DEFAULT_MSG_KEY = "_msg"
  DEFAULT_CLIENT_ID = "unknown"

  attr_reader :topic, :body

  def self.from_string(topic, body)
    Message.new(topic, { DEFAULT_MSG_KEY => body })
  end

  def initialize(topic, body)
    @topic = topic
    @body = body
  end

  def tags
    { topic: topic, client_id: client_id }
  end

  private

  def client_id
    @body["clientid"] || DEFAULT_CLIENT_ID
  end
end
