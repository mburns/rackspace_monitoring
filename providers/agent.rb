#
# Cookbook Name:: rackspace_monitoring
#
# Copyright (C) 2015 Rackspace
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def monitoring_repository(action)
  # call with :add or :remote, defaults to :add
  action ||= 'add'.to_sym

  case node['platform_family']
  when 'debian'
    apt_repository 'rackspace_monitoring' do
      uri "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['lsb']['release']}-x86_64"
      distribution 'cloudmonitoring'
      components ['main']
      key "https://monitoring.api.rackspacecloud.com/pki/agent/#{node['platform']}-#{node['platform_version'][0]}.asc"
      action action
    end
  when 'rhel'
    yum_repository 'rackspace_monitoring' do
      description 'Rackspace Monitoring Agent package repository'
      baseurl "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['platform_version'][0]}-x86_64"
      gpgkey "https://monitoring.api.rackspacecloud.com/pki/agent/#{node['platform']}-#{node['platform_version'][0]}.asc"
      enabled true
      gpgcheck true
      action action
    end
  end
end

action :create do
  token = new_resource.token || node['monitoring']['agent']['token']
  id = new_resource.id || node['monitoring']['agent']['id'] || node['fqdn']

  snet_region = new_resource.snet_region
  endpoints = new_resource.endpoints
  proxy_url = new_resource.proxy_url
  query_endpoints = new_resource.query_endpoints

  fail 'agent token must be defined, either on the node or in data bags' if token.nil?

  unless node['monitoring']['enabled']
    Chef::Log.info("Monitoring is disabled, set your node['rackspace']['cloud_credentials']")
    next
  end

  monitoring_repository(:add)

  package 'rackspace-monitoring-agent' do
    if node['monitoring']['agent']['version'] == 'latest'
      action :upgrade
    else
      version node['monitoring']['agent']['version']
      action :install
    end
    notifies :restart, 'service[rackspace-monitoring-agent]'
  end

  template '/etc/rackspace-monitoring-agent.cfg' do
    cookbook 'rackspace_monitoring'
    owner 'root'
    group 'root'
    mode '00600'
    variables(
      id: id,
      token: token,
      endpoints: endpoints,
      snet_region: snet_region,
      proxy_url: proxy_url,
      query_endpoints: query_endpoints
    )
    notifies :restart, 'service[rackspace-monitoring-agent]', :delayed
  end

  service 'rackspace-monitoring-agent' do
    supports start: true, status: true, stop: true, restart: true
    case node[:platform]
    when 'ubuntu'
      if node[:platform_version].to_f >= 9.10 && node[:platform_version].to_f <= 14.10
        provider Chef::Provider::Service::Upstart
      end
    end
    action %w(enable start)
    only_if { node['monitoring']['enabled'] == true }
  end
end

action :delete do
  service 'rackspace-monitoring-agent' do
    action %w(disable stop)
  end

  file '/etc/rackspace-monitoring-agent.cfg' do
    action :delete
  end

  monitoring_repository(:remove)

  package 'rackspace-monitoring-agent' do
    action :remove
  end
end

action :disable do
  service 'rackspace-monitoring-agent' do
    action %w(disable stop)
  end
end

action :enable do
  service 'rackspace-monitoring-agent' do
    action %w(enable start)
  end
end

alias_method :action_add, :action_create
alias_method :action_remove, :action_delete
alias_method :action_stop, :action_disable
alias_method :action_start, :action_enable
