rackspace_monitoring_check 'cpu' do
  type 'agent.cpu'
end

rackspace_monitoring_check 'load' do
  type 'agent.load'
end

rackspace_monitoring_check 'memory' do
  type 'agent.memory'
  info(
    consecutive_count: 1,
    cookbook: 'rackspace_monitoring'
  )
end

rackspace_monitoring_check 'Network - eth0' do
  type 'agent.network'
  info(
    target: 'eth0',
    options: values
  )
end
