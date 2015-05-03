value = {
  'label'     => 'chef-client'
  'disabled'  => false
  'period'    => 60
  'timeout'   => 30
  'file_url'  => 'https://raw.githubusercontent.com/racker/rackspace-monitoring-agent-plugins-contrib/master/chef_node_checkin.py'
  'cookbook'  => 'rackspace_monitoring'
  'details'   => {
    'file'     => 'chef_node_checkin.py'
    'args'     => []
    'timeout'  => 60
  },
  'alarm'     => {
    'label'   => ''
    'notification_plan_id' => 'npTechnicalContactsEmail'
  }
}

rackspace_monitoring_plugin value['label'] do
  file value['details']['file']
  source value['file_url']
  cookbook value['cookbook']
  info value
end
