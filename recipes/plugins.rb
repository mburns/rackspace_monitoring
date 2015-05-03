#
# Cookbook Name:: rackspace_monitoring
# Recipe:: plugins
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

directory '/etc/rackspace-monitoring-agent.conf.d'

# default set of plugins
directory '/usr/lib/rackspace-monitoring-agent/plugins' do
  owner 'root'
  group 'root'
  mode '00755'
  recursive true
end
remote_directory '/usr/lib/rackspace-monitoring-agent/plugins' do
  source 'plugins'
  cookbook 'rackspace_monitoring'
  owner 'root'
  group 'root'
  mode '00755'
  files_mode '755'
end

# dynamically add more agent plugins via attributes
unless node['monitoring']['plugins'].empty?
  node['monitoring']['plugins'].each do |plugin_name, value|
    rackspace_monitoring_plugin value['label'] || plugin_name do
      file value['details']['file']
      source value['file_url']
      cookbook value['cookbook']
      info value
    end
  end
end
