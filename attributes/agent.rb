default['monitoring']['agent'] = {}
default['monitoring']['agent']['id'] = node['fqdn'] || node['hostname']
default['monitoring']['agent']['version'] = 'latest'