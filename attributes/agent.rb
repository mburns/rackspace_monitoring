default['monitoring']['agent'] = {}
default['monitoring']['agent']['id'] = node['fqdn'] || node['hostname']
default['monitoring']['agent']['channel'] = nil
default['monitoring']['agent']['version'] = 'latest'
