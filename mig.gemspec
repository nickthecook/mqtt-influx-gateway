Gem::Specification.new do |s|
  s.name = 'mqtt-influx-gateway'
  s.version = '0.0.1'
  s.authors = [
    'nickthecook@gmail.com'
  ]
  s.date = '2018-09-17'
  s.summary = 'pings mqtt services'
  s.files = Dir[
    'Gemfile',
    'bin/*',
    'etc/*',
    'lib/*',
  ]
  s.executables << 'mig'
  s.add_runtime_dependency 'mqtt_service', '~> 0.5', '>= 0.5.8'
  s.add_runtime_dependency 'statsd-ruby', '~> 1.5', '>= 1.5.0'
end
