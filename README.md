# rackspace_monitoring cookbook

This is the [Rackspace Monitoring](http://www.rackspace.com/cloud/monitoring) library cookbook to setup a local agent service and health checks using the Rackspace's global monitoring system. The agent is based on an open source framework

## Supported Platforms

Currently Debian (Ubuntu) and Redhat (CentOS, Fedora) families are supported.

*Pull Requests adding support for  *BSD or Windows are welcome.*

## Attributes

All you need to use Rackspace Monitoring is a Rackspace account. Set these attributes so the agent can be configured to report checks to your account.

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['rackspace']['cloud_credentials']['username']</tt></td>
    <td>String</td>
    <td>Your Rackspace account (**required**)</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['rackspace']['cloud_credentials']['api_key']</tt></td>
    <td>String</td>
    <td>Your Rackspace API Key (**required**)</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['monitoring']['notification_plan_id']</tt></td>
    <td>String</td>
    <td></td>
    <td><tt>npTechnicalContactsEmail</tt></td>
  </tr>
  <tr>
    <td><tt>['monitoring']['endpoints']</tt></td>
    <td>Array</td>
    <td></td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['monitoring']['confd']</tt></td>
    <td>String</td>
    <td>Path to save check (.yaml) files</td>
    <td><tt>/etc/rackspace-monitoring-agent.conf.d</tt></td>
  </tr>
  <tr>
    <td><tt>['monitoring']['plugind']</tt></td>
    <td>String</td>
    <td>Path to save plugins used by checks</td>
    <td><tt>/usr/lib/rackspace-monitoring-agent/plugins</tt></td>
  </tr>
  <tr>
    <td><tt>['monitoring']['zones']</tt></td>
    <td>Array of Hashes</td>
    <td>The six (6) default Monitoring Zones</td>
    <td><tt><pre>
      [
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
      ]</pre></tt></td>
  </tr>
  <tr>
    <td><tt>['monitoring']['agent']['id']</tt></td>
    <td>String</td>
    <td>Path to save plugins used by checks</td>
    <td><tt>node['fqdn']</tt></td>
  </tr>
  <tr>
    <td><tt>['monitoring']['agent']['channel']</tt></td>
    <td>String</td>
    <td></td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['monitoring']['agent']['version']</tt></td>
    <td>String</td>
    <td></td>
    <td><tt>latest</tt></td>
  </tr>
</table>

## Usage

This cookbook provides 2 LWRPs, for creating rackspace agents (`rackspace_monitoring_agent`) and checks for that agent to perform (`rackspace_monitoring_check`). An agent can be configured with no checks, but not vice versa.

Agent:
```shell
rackspac_monitoring_agent 'foo' do
  token 'bar'
end
```

Check:
```shell
rackspac_monitoring_check 'foo' do
  type 'agent.memory'
end
```

Plugin ([more examples](https://github.com/racker/rackspace-monitoring-agent-plugins-contrib)):
```shell
rackspace_monitoring_check 'baz' do
  type 'agent.plugin'
  source 'api_limit_ram_usage.py'
end
```


# Agent

The [Rackspace Monitoring Agent](https://github.com/virgo-agent-toolkit/rackspace-monitoring-agent) is open source. It is installed as a service and runs as a priviledged process on your server or VM to gather and relay real-time monitoring data about your infrastructure. The Agent uses plugins (shell scripts) to collect data and checks (yaml files) to alert under the right circumstances.

## Checks

Checks are YAML files that define the frequency, timeout and alarms to report and act on a given bit of data. A check might report when free disk space reaches <=10%.

## Plugins

Plugins are custom [custom script](http://docs.rackspace.com/cm/api/v1.0/cm-devguide/content/appendix-check-types-agent.html#section-ct-agent.plugin) a check can run to get back information.

Plugin are programs or scripts (BASH, Python, Ruby, etc)  that computes some metrics for a service (haproxy) or a system property (free disk space, open file descriptors) and returns that data for the Agent to make use of in Checks. A Check must reference the filename of a Plugin and have the type `agent.plugin`.

## Prior Art

This cookbook borrows heavily and often directly from the following cookbooks:

 * https://github.com/racker/cookbook-cloudmonitoring
 * https://github.com/racker/cookbook-reach-monitoring
 * https://github.com/racker/managed-cloud-cloudmonitoring
 * https://github.com/rackspace-cookbooks/rackspace_cloudmonitoring
 * https://github.com/rackspace-cookbooks/rackspace_cloud_monitoring
 * https://github.com/rackspace-cookbooks/platformstack
