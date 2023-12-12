# Cookbook Name:: rblogstatter
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

    dnf_package "rb-logstatter" do
      action :upgrade
      flush_cache[:before]
    end

    directory config_dir do #/etc/redborder-ale
      owner "logstatter"
      group "logstatter"
      mode '700'
      action :create
    end

    template "/etc/logstatter/logstatter.conf" do
      source "rb-logstatter_config.conf.erb"
      owner "logstatter"
      group "logstatter"
      mode 0644
      retries 2
      variables(
        logstash_monitors: logstash_monitors,
        logstash_pipelines: logstash_pipelines,
        base_url: base_url,
        kafka_brokers: kafka_brokers,
        kafka_topic: kafka_topic,
        request_sleep: request_sleep
      )
      cookbook "rblogstatter"
      notifies :restart, "service[rb-logstatter]", :delayed
  end

  service "rb-logstatter" do
      service_name "rb-logstatter"
      ignore_failure true
      supports :status => true, :reload => true, :restart => true
      action [:enable, :start]
  end

    Chef::Log.info("cookbook redborder-logstatter has been processed.")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    service "rb-logstatter" do
      service_name "rb-logstatter"
      supports :status => true, :restart => true, :start => true, :enable => true, :disable => true
      action [:disable, :stop]
    end
    Chef::Log.info("cookbook redborder-logstatter has been processed.")
  rescue => e
    Chef::Log.error(e.message)
  end
end


action :register do #Usually used to register in consul
  begin
    if !node["rb-ale"]["registered"]
      query = {}
      query["ID"] = "rb-ale-#{node["hostname"]}"
      query["Name"] = "rb-ale"
      query["Address"] = "#{node["ipaddress"]}"
      query["Port"] = 7779
      json_query = Chef::JSONCompat.to_json(query)

      execute 'Register service in consul' do
        command "curl -X PUT http://localhost:8500/v1/agent/service/register -d '#{json_query}' &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.normal["rb-ale"]["registered"] = true
    end
    Chef::Log.info("rb-ale service has been registered in consul")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :deregister do #Usually used to deregister from consul
  begin
    if node["rb-ale"]["registered"]
      execute 'Deregister service in consul' do
        command "curl -X PUT http://localhost:8500/v1/agent/service/deregister/rb-ale-#{node["hostname"]} &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.normal["rb-ale"]["registered"] = false
    end
    Chef::Log.info("rb-ale service has been deregistered from consul")
  rescue => e
    Chef::Log.error(e.message)
  end
end
