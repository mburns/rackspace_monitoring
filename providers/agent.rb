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

  # add package repository
  case node['platform_family']
  when 'debian', 'ubuntu'
    apt_repository 'rackspace_monitoring' do
      uri "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['lsb']['release']}-x86_64"
      distribution 'cloudmonitoring'
      components ['main']
      key "https://monitoring.api.rackspacecloud.com/pki/agent/#{node['platform']}-#{node['platform_version'][0]}.asc"
    end
  when 'rhel', 'centos', 'amazon', 'oracle', 'fedora'
    yum_repository 'rackspace_monitoring' do
      description 'Rackspace Monitoring Agent package repository'
      baseurl "https://stable.packages.cloudmonitoring.rackspace.com/#{node['platform']}-#{node['platform_version'][0]}-x86_64"
      gpgkey "https://monitoring.api.rackspacecloud.com/pki/agent/#{node['platform']}-#{node['platform_version'][0]}.asc"
      enabled true
      gpgcheck true
    end
  end

  package 'rackspace-monitoring-agent' do
    if node['monitoring']['agent']['version'] == 'latest'
      action :upgrade
    else
      version node['monitoring']['agent']['version']
      action :install
    end
    notifies :restart, 'service[rackspace-monitoring-agent]'
  end

  execute 'agent-setup-cloud' do
    command <<-EOH
      rackspace-monitoring-agent --setup \
        --username #{node['rackspace']['cloud_credentials']['username']} \
        --apikey #{node['rackspace']['cloud_credentials']['api_key']}
      EOH
    # the filesize is zero if the agent has not been configured
    only_if { File.size?('/etc/rackspace-monitoring-agent.cfg').nil? }
  end

  template '/etc/rackspace-monitoring-agent.cfg' do
    cookbook 'rackspace_monitoring'
    owner 'root'
    group 'root'
    mode '00600'
    variables(
      id: id,
      token: token,
      endpoints: endpoints
    )
    notifies :restart, 'service[rackspace-monitoring-agent]', :delayed
  end

  service 'rackspace-monitoring-agent' do
    supports value_for_platform(
      "ubuntu" => { "default" => [:start, :stop, :restart, :status] },
      "default" => { "default" => [:start, :stop] }
    )
    case node[:platform]
      when "ubuntu"
      if node[:platform_version].to_f >= 9.10 && node[:platform_version].to_f <= 14.10
        provider Chef::Provider::Service::Upstart
      end
    end
    action [:start, :enable]
    only_if { node['monitoring']['enabled'] == true }
  end
end

action :delete do
  service 'rackspace-monitoring-agent' do
    action [:stop, :disable]
  end

  file '/etc/rackspace-monitoring-agent.cfg' do
    action :delete
  end

  when 'debian', 'ubuntu'
    apt_repository 'rackspace_monitoring' do
      action :remove
    end
  when 'rhel', 'centos', 'amazon', 'oracle', 'fedora'
    yum_repository 'rackspace_monitoring' do
      action :remove
    end
  end

  package 'rackspace-monitoring-agent' do
    action :remove
  end
end

action :disable do
  package 'rackspace-monitoring-agent' do
    action [:disable, :stop]
  end
end

action :enable do
  package 'rackspace-monitoring-agent' do
    action [:enable, :start]
  end
end
