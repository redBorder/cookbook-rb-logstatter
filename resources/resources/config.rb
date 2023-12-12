# Cookbook Name :: rblogstatter
#
# Resource:: config

actions :add, :remove
default_action :add

attribute :config_dir, kind_of: String, default: "/etc/logstatter"
attribute :kafka_brokers, kind_of: Array, default: ["kafka.service:9092"]
attribute :base_url, kind_of: String, default: "http://localhost:9600"
attribute :kafka_topic, kind_of: String, default: 'rb_monitor'
attribute :request_sleep, kind_of: Integer, default: 200
attribute :logstash_monitors, kind_of: Array, default: [
  'logstash_cpu',
  'logstash_load_1',
  'logstash_load_5',
  'logstash_load_15',
  'logstash_heap',
  'logstash_memory',
  'logstash_events_per_pipeline',
  'logstash_events_count_queue',
  'logstash_events_count_queue_bytes'
]
attribute :logstash_pipelines, kind_of: Array, default: [
  'vault-pipeline',
  'sflow-pipeline',
  'netflow-pipeline',
  'scanner-pipeline',
  'location-pipeline',
  'nmsp-pipeline',
  'radius-pipeline',
  'meraki-pipeline',
  'mobility-pipeline',
  'rbwindow-pipeline',
  'monitor-pipeline',
  'bulkstats-pipeline',
  'redfish-pipeline'
]
