# encoding: UTF-8

if node['rackspace']['cloud_credentials']['username'].nil? || node['rackspace']['cloud_credentials']['api_key'].nil?
  default['monitoring']['enabled'] = false
else
  default['monitoring']['enabled'] = true
end

default['monitoring']['notification_plan_id'] = 'npTechnicalContactsEmail'
default['monitoring']['endpoints'] = [] # This should be a list of strings like 'x.x.x.x:port'

default['monitoring']['confd'] = '/etc/rackspace-monitoring-agent.conf.d'
default['monitoring']['plugind'] = '/usr/lib/rackspace-monitoring-agent/plugins'

# Rackspace Monitoring IP ranges that will send or receive check or agent data
default['monitoring']['zones'] = [
  {
    'id' => 'mzdfw',
    'label' => 'Dallas Fort Worth (DFW)',
    'v6' => '2001:4800:7902:0001::/64',
    'v4' => '50.56.142.128/26'
  },
  {
    'id' => 'mzhkg',
    'label' => 'Hong Kong (HKG)',
    'v6' => '2401:1800:7902:0001::/64',
    'v4' => '180.150.149.64/26'
  },
  {
    'id' => 'mziad',
    'label' => 'Northern Virginia (IAD)',
    'v6' => '2001:4802:7902:0001::/64',
    'v4' => '69.20.52.192/26'
  },
  {
    'id' => 'mzlon',
    'label' => 'London (LON)',
    'v6' => '2a00:1a48:7902:0001::/64',
    'v4' => '78.136.44.0/26'
  },
  {
    'id' => 'mzord',
    'label' => 'Chicago (ORD)',
    'country_code' => 'US',
    'v6' => '2001:4801:7902:0001::/64',
    'v4' => '50.57.61.0/26'
  },
  {
    'id' => 'mzsyd',
    'label' => 'Sydney (SYD)',
    'v6' => '2401:1801:7902:0001::/64',
    'v4' => '119.9.5.0/26'
  }
]
