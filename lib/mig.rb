#!/usr/bin/env ruby

require 'mqtt_service'
require 'statsd-instrument'

class Mig < MqttService
  def initialize(config_path: nil)
    config_path ||= self.class.build_config_filename(__dir__)

    puts "Sending #{statsd_implementation} metrics to udp://#{statsd_addr} in mode '#{statsd_mode}'."
    StatsD.mode = statsd_mode if StatsD.respond_to?(:mode=)
    StatsD.server = statsd_addr if StatsD.respond_to?(:server=)
    StatsD.implementation = statsd_implementation if StatsD.respond_to?(:mode=)

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
    ENV["STATSD_ENV"] || :production
  end

  def statsd_implementation
    ENV["STATSD_IMPLEMENTATION"] || :datadog
  end

  def statsd_addr
    @statsd_addr = ENV["STATSD_ADDR"]
  end
end
