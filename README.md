# rackspace_monitoring cookbook

This is the [Rackspace Monitoring](http://www.rackspace.com/cloud/monitoring) library cookbook to setup a local agent service and health checks using the Rackspace's global monitoring system. The agent is based on an open source framework

## Usage

This cookbook provides 2 LWRPs, for creating rackspace agents (`rackspace_monitoring_agent`) and checks for that agent to perform (`rackspace_monitoring_check`). An agent can be configured with no checks, but not vice versa.

# Agent

The [Rackspace Monitoring Agent](https://github.com/virgo-agent-toolkit/rackspace-monitoring-agent) is open source. It is installed as a service and runs as a priviledged process on your server or VM to gather and relay real-time monitoring data about your infrastructure. The Agent uses plugins (shell scripts) to collect data and checks (yaml files) to alert under the right circumstances.

## Checks

Checks are YAML files that define the frequency, timeout and alarms to report and act on a given bit of data. A check might report when free disk space reaches <=10%.

## Plugins

The Agent can run common checks against the system by default, but can also be expanded using [custom plugins](http://docs.rackspace.com/cm/api/v1.0/cm-devguide/content/appendix-check-types-agent.html#section-ct-agent.plugin). A plugin is a program or script (BASH, Python, Ruby, etc)  that computes some metrics for a service (haproxy) or a system property (free disk space, open file descriptors) and returns that data for the Agent to make use of in Checks.

## Attributes

All you need to use Rackspace Monitoring is a Rackspace account. Set these attributes so the agent can be configured to report checks to your account.

`node['rackspace']['cloud_credentials']['username']`
`node['rackspace']['cloud_credentials']['api_key']`

## Prior Art

This cookbook borrows heavily and often directly from the following cookbooks:

 * https://github.com/racker/cookbook-cloudmonitoring
 * https://github.com/racker/cookbook-reach-monitoring
 * https://github.com/racker/managed-cloud-cloudmonitoring
 * https://github.com/rackspace-cookbooks/rackspace_cloudmonitoring
 * https://github.com/rackspace-cookbooks/rackspace_cloud_monitoring
 * https://github.com/rackspace-cookbooks/platformstack
