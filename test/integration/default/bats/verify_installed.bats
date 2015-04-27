@test "rackspace-monitoring-agent is installed and in the path" {
  which rackspace-monitoring-agent
}

@test "rackspace-monitoring-agent configuration exists" {
  cat /etc/rackspace-monitoring-agent.cfg | grep "monitoring_token"
}