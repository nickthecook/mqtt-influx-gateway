#!/usr/bin/env ruby

require 'mqtt_service'
require 'statsd-instrument'

class Mig < MqttService
  def initialize(config_path: nil)
    config_path ||= self.class.build_config_filename(__dir__)

    puts "Sending #{statsd_implementation} metrics to udp://#{statsd_addr} in mode '#{statsd_mode}'."

    super(config_path: config_path)
  end

  def mqtt_receive(topic, msg, msg_hash)
    msg = if msg_hash.nil?
      Message.from_string(topic, msg)
    else
      Message.new(topic, msg_hash)
    end

    count(msg)
  end

  private

  def count(msg)
    StatsD.increment(metric, tags: msg.tags)
  end

  def metric
    @metric ||= @config.mig.metric
  end

  def statsd_mode
    @statsd_mode ||= ENV["STATSD_ENV"] || :development
  end

  def statsd_implementation
    @statsd_implementation ||= ENV["STATSD_IMPLEMENTATION"] || :datadog
  end

  def statsd_addr
    @statsd_addr = ENV["STATSD_ADDR"] || "localhost:8125"
  end
end
