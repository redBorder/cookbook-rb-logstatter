# Cookbook:: rblogstatter
#
# Provider:: config
#
action :add do
  begin
    config_dir = new_resource.config_dir
    logstash_monitors = new_resource.logstash_monitors
    logstash_pipelines = new_resource.logstash_pipelines
    base_url = new_resource.base_url
    kafka_brokers = new_resource.kafka_brokers
    kafka_topic = new_resource.kafka_topic
    request_sleep = new_resource.request_sleep

    dnf_package 'rb-logstatter' do
      action :upgrade
      flush_cache[:before]
    end

    directory config_dir do # /etc/redborder-ale
      owner 'logstatter'
      group 'logstatter'
      mode '700'
      action :create
    end

    template '/etc/logstatter/logstatter.conf' do
      source 'rb-logstatter_config.conf.erb'
      owner 'logstatter'
      group 'logstatter'
      mode '644'
      retries 2
      variables(
        logstash_monitors: logstash_monitors,
        logstash_pipelines: logstash_pipelines,
        base_url: base_url,
        kafka_brokers: kafka_brokers,
        kafka_topic: kafka_topic,
        request_sleep: request_sleep
      )
      cookbook 'rblogstatter'
      notifies :restart, 'service[rb-logstatter]', :delayed
    end

    service 'rb-logstatter' do
      service_name 'rb-logstatter'
      ignore_failure true
      supports status: true, reload: true, restart: true
      action [:enable, :start]
    end

    Chef::Log.info('cookbook redborder-logstatter has been processed.')
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    service 'rb-logstatter' do
      service_name 'rb-logstatter'
      supports status: true, restart: true, start: true, enable: true, disable: true
      action [:disable, :stop]
    end
    Chef::Log.info('cookbook redborder-logstatter has been processed.')
  rescue => e
    Chef::Log.error(e.message)
  end
end
