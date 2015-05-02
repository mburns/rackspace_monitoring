#
# Cookbook Name:: rackspace_monitoring
# Recipe:: package
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

case node['platform_family']
when 'debian'
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

if node['monitoring']['enabled']
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
end
