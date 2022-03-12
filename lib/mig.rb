#!/usr/bin/env ruby

require 'mqtt_service'
require 'statsd-instrument'

class Mig < MqttService
  def initialize(config_path: nil)
    super(config_path: config_path)
  end

  def mqtt_receive(topic, msg, msg_hash)
    msg = if msg_hash.nil?
      Message.from_string(client_id, topic, msg)
    else
      Message.new(client_id, topic, msg_hash)
    end

    count(msg)
  end

  private

  def count(msg)
    StatsD.increment(metric, tags: msg.tags)
  end

  def client_id
    @client_id ||= @config.mqtt.client_id
  end

  def metric
    @metric ||= @config.mig.metric
  end
end
