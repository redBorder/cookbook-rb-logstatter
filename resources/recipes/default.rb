#
# Cookbook Name:: rbale
# Recipe:: default
#
# redborder
#
#

rblogstatter_config "config" do
  name node["hostname"]
  action :add
end
