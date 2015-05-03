confd = '/etc/rackspace-monitoring-agent.conf.d'

def get_name_from_type(type, target) do
  # Given a type (agent.plugin.foo_bar), return a file name to use
  case type
  when 'agent.network'
    name = "network.#{target}"
  when 'agent.redis'
    host = 'localhost'
    port = 6379
    name = "redis.#{host}.#{port}"
  when 'agent.plugin.dir_stats'
    name = "directory-#{label.gsub(' ', '').gsub('/', '').downcase}.yaml"
  when 'agent.plugin.haproxy'
    name = "haproxy-#{label.gsub(' ', '').gsub('/', '').downcase}"
  when 'agent.plugin.check-mtime'
    name = "check-mtime-#{label.gsub(' ', '').gsub('/', '').downcase}"
  when 'agent.plugin.curl'
    name = "plugin.curl.#{label.gsub(' ', '').gsub('/', '').downcase}"
  when 'remote.http'
    name = "http-#{label.gsub(' ', '').gsub('/', '').downcase}"
  when 'remote.ping'
    name = "ping-#{label.gsub(' ', '').gsub('/', '').downcase}"
  else
    name = type

    unless %w(agent plugin remote).include?(type.split(/[.\s]/)[0])
      fail "Invalid type, expecting '{agent,plugin,remote}.foo(.bar)' got '#{type}'."
    end
  end

  return name
end
action :create do
  directory confd do
    owner 'root'
    group 'root'
    mode '00755'
    recursive true
    action :create
  end

  service 'rackspace-monitoring-agent' do
    supports restart: true
    action :nothing
  end

  type = new_resource.type
  label = new_resource.label
  details = new_resource.details || {}
  notification_plan_id = details[:notification_plan_id] || node['monitoring']['notification_plan_id']
  consecutive_count = details[:consecutive_count]
  target_alias = new_resource.target_alias
  target_hostname = new_resource.target_hostname
  target_resolver = new_resource.target_resolver
  monitoring_zones = new_resource.monitoring_zones || []

  if notification_plan_id.nil?
    fail "either notification_plan_id or node['monitoring']['notification_plan_id'] must be defined"
  end

  fail 'check type cannot be null' if type.nil?

  if type =~ /remote/ && monitoring_zones.count == 0
    fail 'monitoring_zones must be defined for remote checks. Example: [mzdfw, mzord, mziad]'
  end

  name = get_name_from_type(type, details[:target])

  Chef::Log.debug("Creating check #{name} of #{type}.")

  template "#{confd}/#{name}.yaml" do
    source "confd/#{type}.yaml.erb"
    owner 'root'
    group 'root'
    mode '00644'
    variables(
      type: type,
      label: label,
      notification_plan_id: notification_plan_id,
      consecutive_count: consecutive_count,
      target_alias: target_alias,
      target_hostname: target_hostname,
      target_resolver: target_resolver,
      file_to_check: details[:file_to_check],
      frontend_age_critical_min: details[:frontend_age_critical_min] || 0,
      frontend_age_warning_min: details[:frontend_age_warning_min] || 100,
      target: details[:target],
      count: details[:count],
      url: details[:url],
      expected_code: details[:expected_code],
      monitoring_zones: monitoring_zones,
      max_files_warn: details[:max_files_warn] || nil,
      max_files_crit: details[:max_files_crit] || nil,
      max_size_mb_warn: details[:max_size_mb_warn] || nil,
      max_size_mb_crit: details[:max_size_mb_crit] || nil
    )
    notifies :restart, resources(service: 'rackspace-monitoring-agent'), :delayed
  end
end

action :delete do
  type = new_resource.type
  name = get_name_from_type(type, details[:target])
  
  file "#{confd}/#{name}.yaml" do
    action :delete
  end
end