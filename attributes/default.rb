# encoding: UTF-8

if node['rackspace']['cloud_credentials']['username'].nil? || node['rackspace']['cloud_credentials']['api_key'].nil?
  default['monitoring']['enabled'] = false
else
  default['monitoring']['enabled'] = true
end

default['monitoring']['notification_plan_id'] = 'npTechnicalContactsEmail'
