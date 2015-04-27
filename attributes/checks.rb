warn_load_threshold = node['cpu']['total'] * 2
crit_load_threshold = node['cpu']['total'] * 3

default['monitoring']['cpu']['disabled']         = false
default['monitoring']['cpu']['alarm']            = false
default['monitoring']['cpu']['period']           = 90
default['monitoring']['cpu']['timeout']          = 30
default['monitoring']['cpu']['crit']             = 95
default['monitoring']['cpu']['warn']             = 90
default['monitoring']['cpu']['cookbook']         = 'rackspace_monitoring'

default['monitoring']['disk']['disabled']        = false
default['monitoring']['disk']['alarm']           = false
default['monitoring']['disk']['target']          = '/dev/xvda1'
default['monitoring']['disk']['target_mountpoint'] = '/'
default['monitoring']['disk']['period']          = 60
default['monitoring']['disk']['timeout']         = 30
default['monitoring']['disk']['alarm_criteria']  = ''
default['monitoring']['disk']['cookbook']        = 'rackspace_monitoring'

default['monitoring']['filesystem']['disabled']  = false
default['monitoring']['filesystem']['alarm']     = false
default['monitoring']['filesystem']['period']    = 60
default['monitoring']['filesystem']['timeout']   = 30
default['monitoring']['filesystem']['crit']      = 90
default['monitoring']['filesystem']['warn']      = 80
default['monitoring']['filesystem']['cookbook']  = 'rackspace_monitoring'
default['monitoring']['filesystem']['non_monitored_fstypes'] = %w(tmpfs devtmpfs devpts proc mqueue cgroup efivars sysfs sys securityfs configfs fusectl)

# during chefspec tests with fauxhai, node['filesystem'] might be nil
unless node['filesystem'].nil?
  node['filesystem'].each do |key, data|
    next if data['percent_used'].nil? || data['fs_type'].nil?
    next if node['monitoring']['filesystem']['non_monitored_fstypes'].nil?
    next if node['monitoring']['filesystem']['non_monitored_fstypes'].include?(data['fs_type'])
    default['monitoring']['filesystem']['target'][key] = data['mount']
  end
end

default['monitoring']['load']['disabled']        = false
default['monitoring']['load']['alarm']           = false
default['monitoring']['load']['period']          = 60
default['monitoring']['load']['timeout']         = 30
default['monitoring']['load']['crit']            = crit_load_threshold
default['monitoring']['load']['warn']            = warn_load_threshold
default['monitoring']['load']['cookbook']        = 'rackspace_monitoring'

default['monitoring']['memory']['disabled']      = false
default['monitoring']['memory']['alarm']         = false
default['monitoring']['memory']['period']        = 60
default['monitoring']['memory']['timeout']       = 30
default['monitoring']['memory']['crit']          = 95
default['monitoring']['memory']['warn']          = 90
default['monitoring']['memory']['cookbook']      = 'rackspace_monitoring'

default['monitoring']['network']['disabled']     = false
default['monitoring']['network']['alarm']        = false
default['monitoring']['network']['target']       = 'eth0'
default['monitoring']['network']['period']       = 60
default['monitoring']['network']['timeout']      = 30
default['monitoring']['network']['recv']['crit'] = '76000'
default['monitoring']['network']['recv']['warn'] = '56000'
default['monitoring']['network']['send']['crit'] = '76000'
default['monitoring']['network']['send']['warn'] = '56000'
default['monitoring']['network']['cookbook']     = 'rackspace_monitoring'

# NOTE: this is for 'service monitoring' using service_mon.sh. go to the next section for arbitrary monitors.
# Currently for service monitoring, the recipe that sets up the service should add:
# node.default['monitoring']['service']['name'].push('<service_name>')
default['monitoring']['service']['name']         = []
default['monitoring']['service']['disabled']     = false
default['monitoring']['service']['alarm']        = false
default['monitoring']['service']['period']       = 60
default['monitoring']['service']['timeout']      = 30
default['monitoring']['service']['cookbook']     = 'rackspace_monitoring'
default['monitoring']['service_mon']['cookbook'] = 'rackspace_monitoring'

# Remote-http monitors.
default['monitoring']['remote_http']['name']     = []

# arbitrary / non-service-monitors data structure for any arbitrary template
default['monitoring']['custom_monitors']['name'] = []
# Currently for arbitrary monitoring, the recipe that sets up the monitor should add:
# node.default['monitoring']['custom_monitors']['name'].push('<service_name>')
# and then populate node['monitoring'][service_name][setting] with your values
# default['monitoring']['custom_monitors'][<name>]['source'] = 'my_monitor.yaml.erb'
# default['monitoring']['custom_monitors'][<name>]['cookbook'] = 'your_cookbook'
# default['monitoring']['custom_monitors'][<name>]['variables'] = { :warning => 'foo' }
