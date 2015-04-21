default['monitoring']['plugins'] = {}
# Generic plugin support. Requires hash like:
default['monitoring']['plugins']['chef-client']['label'] = 'chef-client'
default['monitoring']['plugins']['chef-client']['disabled'] = false
default['monitoring']['plugins']['chef-client']['period'] = 60
default['monitoring']['plugins']['chef-client']['timeout'] = 30
default['monitoring']['plugins']['chef-client']['file_url'] = 'https://raw.githubusercontent.com/racker/rackspace-monitoring-agent-plugins-contrib/master/chef_node_checkin.py'
default['monitoring']['plugins']['chef-client']['cookbook'] = 'rackspace-monitoring'
default['monitoring']['plugins']['chef-client']['details']['file'] = 'chef_node_checkin.py'
default['monitoring']['plugins']['chef-client']['details']['args'] = []
default['monitoring']['plugins']['chef-client']['details']['timeout'] = 60
default['monitoring']['plugins']['chef-client']['alarm']['label'] = ''
default['monitoring']['plugins']['chef-client']['alarm']['notification_plan_id'] = 'npMANAGED'
default['monitoring']['plugins']['chef-client']['alarm']['criteria'] = ''