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

def get_name_from_type(type, target)
  # Given a type ("agent.network") and an optional target ("eth0"),
  # return a *.yaml file name to write the agent check out to.
  # This includes stripping invalid characters for the file name

  unless %w(agent plugin remote).include?(type.split(/[.\s]/)[0])
    fail "Invalid type, expecting '{agent,plugin,remote}.foo(.bar)', got '#{type}'."
  end

  case type
  when 'agent.network'
    name = "network-#{target.gsub(' ', '').gsub('/', '').gsub('.', '-').downcase}"
  when 'agent.redis'
    host = 'localhost' # TODO : fixme
    port = 6379
    name = "redis-#{host}-#{port}"
  when /^agent\.plugin(?:\.)?(.*)/
    #  prepend name with 'foo-' if type is 'agent.plugin.foo', to namespace checks
    prefix = type.split('.').last
    # prefix = Regexp.last_match(1).nil? ? 'plugin' : Regexp.last_match(1) # type.gsub(/^agent\.plugin(\.)?/, '')
    name = "#{prefix}#{target.gsub(' ', '').gsub('/', '-').gsub('.', '-').downcase}"
  when 'remote.http'
    name = "http-#{target.gsub(' ', '').gsub('/', '').gsub('.', '-').downcase}"
  when 'remote.ping'
    name = "ping-#{target.gsub(' ', '').gsub('/', '').gsub('.', '-').downcase}"
  else
    name = type
  end

  name
end

action :create do
  Chef::Log.debug("Beginning action[:create] for #{new_resource}")

  label = new_resource.label
  type = new_resource.type # agent.foo
  info = new_resource.info || {}
  notification_plan_id = info[notification_plan_id] || node['monitoring']['notification_plan_id']
  consecutive_count = info['consecutive_count'] || 2
  period = new_resource.period || info['period']
  timeout = new_resource.timeout || info['timeout']
  alarm = new_resource.alarm || info['alarm'] || node['monitoring']['alarm']

  cookbook_name = info['cookbook'] || 'rackspace_monitoring'
  yaml_cookbook = new_resource.yaml_cookbook || 'rackspace_monitoring'
  yaml_source = new_resource.yaml_source

  # remote checks
  target = new_resource.target || info['target'] || ''
  target_alias = new_resource.target_alias
  target_hostname = new_resource.target_hostname
  target_resolver = new_resource.target_resolver
  monitoring_zones = new_resource.monitoring_zones || node['monitoring']['zones'].map { |x| x['id'] }

  # failure conditions
  fail 'check type cannot be nil' if type.nil?
  if notification_plan_id.nil?
    fail "either notification_plan_id or node['monitoring']['notification_plan_id'] must be defined"
  end
  if type =~ /^remote/ && monitoring_zones.count == 0
    fail 'monitoring_zones must be defined for remote checks. Example: [mzdfw, mzord, mziad]'
  end

  # plugin checks require a custom script (plugin) to execute
  if type =~ /^agent\.plugin/
    source = new_resource.source
    file = new_resource.file || source.split('/').last

    directory node['monitoring']['plugind'] do
      owner 'root'
      group 'root'
      mode '00755'
      recursive true
    end
    new_resource.updated_by_last_action(true)

    # copy the `file` (via chef) or `source` (via Internet) to be used by the plugin check
    if source.nil?
      cookbook_file "#{node['monitoring']['plugind']}/#{file}" do
        source file
        cookbook cookbook
        owner 'root'
        group 'root'
        mode '00755'
      end
      new_resource.updated_by_last_action(true)
    else
      if source.include?('/')
        source = "https://raw.githubusercontent.com/racker/rackspace-monitoring-agent-plugins-contrib/master/#{source}"
      end

      remote_file "#{node['monitoring']['plugind']}/#{file}" do
        source source
        owner 'root'
        group 'root'
        mode '00755'
      end
      new_resource.updated_by_last_action(true)
    end
  end

  # determine the filename from by type and target of the check
  name = get_name_from_type(type, target)

  Chef::Log.debug("Creating check #{name} from (#{type}, #{label}, #{info[:target]}).")

  directory node['monitoring']['confd'] do
    owner 'root'
    group 'root'
    mode '00755'
    recursive true
  end
  new_resource.updated_by_last_action(true)

  template "#{node['monitoring']['confd']}/#{name}.yaml" do
    source yaml_source || "confd/#{type}.yaml.erb"
    cookbook yaml_cookbook
    owner 'root'
    group 'root'
    mode '00644'
    variables(
      alarm: alarm,
      consecutive_count: consecutive_count,
      cookbook_name: 'cloud_monitoring',
      disabled: info['disabled'] || false,
      file: file,
      info: info,
      label: label,
      monitoring_zones: monitoring_zones,
      notification_plan_id: notification_plan_id,
      period: period,
      target_alias: target_alias,
      target_hostname: target_hostname,
      target_resolver: target_resolver,
      timeout: timeout,
      type: type
    )
    if node['monitoring']['enabled']
      notifies :restart, 'service[rackspace-monitoring-agent]', :delayed
    end
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  Chef::Log.debug("Beginning action[:delete] for #{new_resource}")

  name = get_name_from_type(type, info['target'])
  file = new_resource.file || info['details']['file'] || new_resource.source.split('/').last

  file "#{node['monitoring']['plugind']}/#{file}" do
    action :delete
  end
  new_resource.updated_by_last_action(true)

  file "#{node['monitoring']['confd']}/#{name}.yaml" do
    action :delete
  end
  new_resource.updated_by_last_action(true)
end

alias_method :action_add, :action_create
alias_method :action_remove, :action_delete
