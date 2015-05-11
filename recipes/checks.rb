#
# Cookbook Name:: rackspace_monitoring
# Recipe:: checks
#
# Copyright 2015. Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# System Health, see: http://docs.rackspace.com/cm/api/v1.0/cm-devguide/content/appendix-check-types-agent.html
%w(
  agent.cpu
  agent.disk
  agent.load_average
  agent.memory
  agent.network
).each do |check|
  monitor = check.partition('.')[2]
  rackspace_monitoring_check monitor do
    type check
    alarm node['monitoring'][monitor]['alarm']
    info(
      node['monitoring'][monitor]
    )
  end
end

# Filesystem
node['monitoring']['filesystem']['target'].each do |disk, mount|
  rackspace_monitoring_check "Filesystem - #{mount}" do
    type 'agent.filesystem'
    alarm node['monitoring']['filesystem']['alarm']
    info(
      disabled: node['monitoring']['filesystem']['disabled'],
      disk: disk,
      target: mount
    )
  end
end

# Network
node['network']['interfaces'].each_pair do |int, values|
  next if %w(lo0 lo loopback0).include?(int) # skip loopback

  rackspace_monitoring_check "Network - #{int}" do
    type 'agent.network'
    target int
    info(
      options: values
    )
  end
end

# Service monitoring
unless node['monitoring']['service']['name'].empty?
  node['monitoring']['service']['name'].each do |service_name|
    rackspace_monitoring_check service_name do
      type 'agent.plugin.service'
      file 'service_mon.sh'
      info(
        disabled: node['monitoring'][monitor]['disabled'],
        cookbook: node['monitoring']['service_mon']['cookbook'],
        service_name: service_name
      )
    end
  end
end

# chef-client
rackspace_monitoring_check node['monitoring']['chef-client']['label'] do
  type 'agent.plugin'
  source node['monitoring']['chef-client']['file_url']
  info(node['monitoring']['chef-client'])
end

# Remote HTTP
node['monitoring']['remote_http'].each_pair do |monitor, values|
  Chef::Log.info("#{monitor} => #{values}. kthxbye")
  rackspace_monitoring_check monitor do
    type 'remote.http'
    info(values)
  end
end

# Custom checks
rackspace_monitoring_check 'directory /etc' do
  type 'agent.plugin.directory'
  file 'dir_stats.sh'
  target '/etc'
  info({})
end

rackspace_monitoring_check 'file mtime /etc/hosts' do
  type 'agent.plugin.file'
  file 'check-mtime.sh'
  target '/etc/hosts'
end
