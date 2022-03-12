# frozen_string_literal: true

class Message
  DEFAULT_MSG_KEY = "_msg"

  attr_reader :client_id, :topic, :body

  def self.from_string(client_id, topic, body)
    Message.new(client_id, topic, { DEFAULT_MSG_KEY => body })
  end

  def initialize(client_id, topic, body)
    @client_id = client_id
    @topic = topic
    @body = body
  end

  def tags
    { topic: topic, client_id: client_id }
  end
end
