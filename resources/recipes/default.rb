#
# Cookbook:: rblogstatter
# Recipe:: default
#
# redborder
#
#

rblogstatter_config 'config' do
  name_property node['hostname']
  action :add
end
