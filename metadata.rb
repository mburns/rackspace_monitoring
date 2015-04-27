name 'rackspace_monitoring'
maintainer 'Rackspace Monitoring'
maintainer_email 'ele-dev@lists.rackspace.com'
license 'Apache 2.0'
description 'Installs/Configures rackspace monitoring'
long_description 'Installs/Configures rackspace monitoring'
version '0.1.0'

%w(ubuntu debian redhat centos amazon oracle).each do |os|
  supports os
end

depends 'apt', '~> 2.6'
depends 'chef-sugar'
depends 'yum'
