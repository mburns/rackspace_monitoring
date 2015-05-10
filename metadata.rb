name 'rackspace_monitoring'
license 'Apache v2.0'
version '0.3.0'
description 'Installs/Configures Rackspace Monitoring'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

maintainer 'Rackspace Monitoring'
maintainer_email 'ele-dev@lists.rackspace.com'

issues_url 'https://github.com/rackerlabs/rackspace_monitoring/issues'
source_url 'https://github.com/rackerlabs/rackspace_monitoring'

%w(ubuntu debian redhat centos amazon oracle).each do |os|
  supports os
end

replaces 'rackspace-cloudmonitoring'
replaces 'rackspace_cloud_monitoring'
replaces 'cookbook-cloudmonitoring'
replaces 'managed-cloud-cloudmonitoring'

depends 'apt', '~> 2.6'
depends 'yum'
depends 'chef-sugar'

provides 'service[rackspace-monitoring-agent]'

recipe 'rackspace_monitoring::agent', 'configures a monitoring agent'
recipe 'rackspace_monitoring::checks', 'configures basic system checks'
