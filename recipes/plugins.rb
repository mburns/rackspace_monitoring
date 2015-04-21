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

directory '/usr/lib/rackspace-monitoring-agent/plugins' do
  owner 'root'
  group 'root'
  mode '00755'
  recursive true
end

# default set of plugins
remote_directory '/usr/lib/rackspace-monitoring-agent/plugins' do
  source 'plugins'
  owner 'root'
  group 'root'
  mode '00755'
  files_mode '00755'
end

# dynamically add more agent plugins via attributes
unless node['monitoring']['plugins'].empty?
  node['monitoring']['plugins'].each do |plugin_name, value|
    # helper variable
    plugin_hash = value

    remote_file "/usr/lib/rackspace-monitoring-agent/plugins/#{plugin_hash['details']['file']}" do
      source plugin_hash['file_url']
      owner 'root'
      group 'root'
      mode '0755'
    end

    template "/etc/rackspace-monitoring-agent.conf.d/monitoring-plugin-#{plugin_name}.yaml" do
      cookbook plugin_hash['cookbook']
      source 'monitoring-plugin.erb'
      owner 'root'
      group 'root'
      mode '00644'
      variables(
        cookbook_name: cookbook_name,
        plugin_check_label: plugin_hash['label'],
        plugin_check_disabled: plugin_hash['disabled'],
        plugin_check_period: plugin_hash['period'],
        plugin_check_timeout: plugin_hash['timeout'],
        plugin_details_file: plugin_hash['details']['file'],
        plugin_details_args: plugin_hash['details']['args'],
        plugin_details_timeout: plugin_hash['details']['timeout'],
        plugin_alarm_label: plugin_hash['alarm']['label'],
        plugin_alarm_notification_plan_id: plugin_hash['alarm']['notification_plan_id'],
        plugin_alarm_criteria: plugin_hash['alarm']['criteria']
      )
      notifies 'restart', 'service[rackspace-monitoring-agent]', :delayed
      only_if { plugin_hash['disabled'] == false }
    end
  end
end