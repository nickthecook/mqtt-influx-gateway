#!/usr/bin/env ruby

require 'mqtt_service'
require 'statsd-ruby'

class Mig < MqttService
  def initialize
    super(config_path: self.class.build_config_filename(__dir__))
  end

  def mqtt_receive(topic, msg, _msg_hash)
    statsd.increment(metric)
  end

  private

  def statsd
    @statsd ||= Statsd.new(statsd_host, statsd_port, statsd_protocol)
  end

  def statsd_protocol
    (ENV["STATSD_PROTOCOL"] || "udp").to_sym
  end

  def statsd_port
    ENV["STATSD_PORT"] || 8125
  end

  def statsd_host
    ENV["STATSD_HOST"] || "localhost"
  end

  def metric
    @metric ||= @config.mig.metric
  end
end
