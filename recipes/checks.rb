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

directory node['monitoring']['confd'] do
  owner 'root'
  group 'root'
  mode '00755'
end

# basic system monitors
[
  'agent.cpu',
  'agent.load',
  'agent.memory'
].each do |type|
  monitor = type.partition('.')[2]
  rackspace_monitoring_check monitor do
    type type
    action :create
    details(
      consecutive_count: 2,
      cookbook: node['monitoring'][monitor]['cookbook']
    )
    only_if { node['monitoring'][monitor]['disabled'] == false }
  end
end

# custom monitors
node['monitoring']['custom_monitors']['name'].each do |monitor|
  monitor_source = node['monitoring']['custom_monitors'][monitor]['source']
  monitor_variables = node['monitoring']['custom_monitors'][monitor]['variables']

  rackspace_monitoring_check monitor do
    type monitor_source
    details(monitor_variables)
    only_if { node['monitoring'][monitor]['disabled'] == false }
  end
end

# http
node['monitoring']['remote_http']['name'].each do |monitor|
  monitor_source = node['monitoring']['remote_http'][monitor]['source']
  monitor_variables = node['monitoring']['remote_http'][monitor]['variables']

  rackspace_monitoring_check monitor do
    type monitor_source || 'remote.http'
    details(monitor_variables)
    only_if { node['monitoring'][monitor]['disabled'] == false }
  end
end

# service monitoring
unless node['monitoring']['service']['name'].empty?

  rackspace_monitoring_plugin 'service_mon.sh' do
    source 'service_mon.sh.erb'
    cookbook node['monitoring']['service_mon']['cookbook']
    details(
      cookbook_name: cookbook_name
    )
  end

  node['monitoring']['service']['name'].each do |service_name|
    rackspace_monitoring_check service_name do
      type 'agent.service'
      action :create
      details(
        service_name: service_name
      )
      only_if { node['monitoring'][monitor]['disabled'] == false }
    end
  end
end

# Network
node['network']['interfaces'].each_pair do |int, values|
  next if %w(lo0 lo loopback0).include?(int)

  rackspace_monitoring_check "Network - #{int}" do
    type 'agent.network'
    action :create
    details(
      target: int,
      options: values
    )
    only_if { node['monitoring']['filesystem']['disabled'] == false }
  end
end

# Filesystem
node['monitoring']['filesystem']['target'].each do |disk, mount|
  rackspace_monitoring_check "Filesystem - #{mount}" do
    type 'agent.filesystem'
    action :create
    details(
      disk: disk,
      target: mount
    )
    only_if { node['monitoring']['filesystem']['disabled'] == false }
  end
end
