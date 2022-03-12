#!/usr/bin/env ruby

require 'mqtt_service'
require 'statsd-instrument'

class Mig < MqttService
  def initialize(config_path: nil)
    config_path ||= self.class.build_config_filename(__dir__)

    puts "Sending #{statsd_implementation} metrics to udp://#{statsd_addr} in mode '#{statsd_mode}'."
    StatsD.mode = statsd_mode
    StatsD.server = statsd_addr
    StatsD.implementation = statsd_implementation

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

  def statsd_mode
    :production
  end

  def statsd_implementation
    :datadog
  end

  def statsd_addr
    @statsd_addr = ENV["STATSD_ADDR"]
  end
end
