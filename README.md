# rackspace_monitoring cookbook

[![Build Status](https://travis-ci.org/rackerlabs/rackspace_monitoring.svg)](https://travis-ci.org/rackerlabs/rackspace_monitoring)

This is the [Rackspace Monitoring](http://www.rackspace.com/cloud/monitoring) library cookbook to setup a local agent service and health checks using the Rackspace's global monitoring system. The agent is based on an open source framework

## Requirements

* Chef 11+
* Rackspace Account (and API Key)

### Supported Platforms

Currently Debian (Ubuntu) and Redhat (CentOS, Fedora) families are supported.

*Pull Requests adding support for *BSD or Windows are welcome.*

## Attributes


Attributes are namespaced under `node['monitoring]` to keep things organized.

Required Attributes:

* `node['rackspace']['cloud_credentials']['username']`
* `node['rackspace']['cloud_credentials']['api_key']`

## Usage

This cookbook provides 2 LWRPs, for creating rackspace agents (`rackspace_monitoring_agent`) and checks for that agent to perform (`rackspace_monitoring_check`). An agent can be configured with no checks, but not vice versa.

### Agent

The [Rackspace Monitoring Agent](https://github.com/virgo-agent-toolkit/rackspace-monitoring-agent) is open source. It is installed as a service and runs as a priviledged process on your server or VM to gather and relay real-time monitoring data about your infrastructure. The Agent uses plugins (shell scripts) to collect data and checks (yaml files) to alert under the right circumstances.

* `node['monitoring']['agent']['id']` ('npTechnicalContactsEmail')
* `node['monitoring']['agent']['channel']`
* `node['monitoring']['agent']['version']` ('latest')

```shell
rackspac_monitoring_agent 'foo' do
  token 'bar'
end
```

### Check

Checks are YAML files that define the frequency, timeout and alarms to report and act on a given peice of data. A check might report when free disk space reaches <=10%.

```shell
rackspac_monitoring_check 'foo' do
  type 'agent.memory'
end
```

#### Plugins

Plugin are programs or scripts (BASH, Python, Ruby, etc)  that computes some metrics for a service (haproxy) or a system property (free disk space, open file 
Plugin ([more examples](https://github.com/racker/rackspace-monitoring-agent-plugins-contrib)):

```shell
rackspace_monitoring_check 'baz' do
  type 'agent.plugin'
  source 'api_limit_ram_usage.py'
end
```

## License and Authors

* Michael Burns <michael.burns@rackspace.com>

This cookbook borrowed heavily and often directly from the following cookbooks:

 * https://github.com/racker/cookbook-cloudmonitoring (dann7387, philk)
 * https://github.com/racker/cookbook-reach-monitoring (thegreenrobot)
 * https://github.com/racker/managed-cloud-cloudmonitoring (johnsocp)
 * https://github.com/rackspace-cookbooks/rackspace_cloudmonitoring (RSTJNII)
 * https://github.com/rackspace-cookbooks/rackspace_cloud_monitoring (jujugrrr)
 * https://github.com/rackspace-cookbooks/platformstack (martinb3, prometheanfire, marcoamorales)
