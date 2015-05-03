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

# Example hash to be parsed
# 'chef-client' = {
#   'label'     => 'chef-client'
#   'disabled'  => false
#   'period'    => 60
#   'timeout'   => 30
#   'file_url'  => 'https://raw.githubusercontent.com/racker/rackspace-monitoring-agent-plugins-contrib/master/chef_node_checkin.py'
#   'cookbook'  => 'rackspace_monitoring'
#   'details'   => {
#     'file'    => 'chef_node_checkin.py'
#     'args'    => []
#     'timeout' => 60
#   },
#   'alarm'     => {
#     'label'   => ''
#     'notification_plan_id' => 'npTechnicalContactsEmail'
#   }
# }

action :create do
  name = new_resource.name
  info = new_resource.info # catch-all hash

  source = new_resource.source || info['file_url']
  file = new_resource.file || info['details']['file']
  cookbook = new_resource.cookbook || info['cookbook']

  directory default['monitoring']['plugind'] do
    owner 'root'
    group 'root'
    mode '00755'
    recursive true
  end

  remote_file "#{node['monitoring']['plugind']}/#{file}" do
    source source
    owner 'root'
    group 'root'
    mode '00755'
  end

  template "#{node['monitoring']['confd']}/monitoring-plugin-#{name}.yaml" do
    cookbook cookbook
    source 'monitoring-plugin.erb'
    owner 'root'
    group 'root'
    mode '00644'
    variables(cookbook_name: cookbook_name,
              plugin_check_label: info['label'] || name,
              plugin_check_disabled: info['disabled'] || false,
              plugin_check_period: info['period'] || 60,
              plugin_check_timeout: info['timeout'] || 30,
              plugin_details_file: info['details']['file'],
              plugin_details_args: info['details']['args'],
              plugin_details_timeout: info['details']['timeout'] || 60,
              plugin_alarm_label: info['alarm']['label'],
              plugin_alarm_notification_plan_id: info['alarm']['notification_plan_id'],
              plugin_alarm_criteria: info['alarm']['criteria'])
    # notifies 'restart', 'service[rackspace-monitoring-agent]', :delayed
    only_if { info['disabled'] == false }
  end
end

action :delete do
  file "#{node['monitoring']['plugind']}/#{file}" do
    action :delete
  end

  file "#{node['monitoring']['confd']}/monitoring-plugin-#{plugin_name}.yaml" do
    action :delete
  end
end

alias_method :action_add, :action_create
alias_method :action_remove, :action_delete
