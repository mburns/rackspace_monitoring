#
# Cookbook Name:: rackspace_monitoring
# Recipe:: agent
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

agent_token = node['monitoring']['agent']['token']

if agent_token.nil?
  raise RuntimeError, 'agent_token variable must be defined, either on the node or in data bags'
end

template '/etc/rackspace-monitoring-agent.cfg' do
  owner 'root'
  group 'root'
  mode '00600'
  variables(
    :monitoring_id => node['monitoring']['agent']['id'],
    :monitoring_token => agent_token,
    :monitoring_upgrade => node['monitoring']['agent']['upgrade']
  )
  notifies :restart, 'service[rackspace-monitoring-agent]', :delayed
end