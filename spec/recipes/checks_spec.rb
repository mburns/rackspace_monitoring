require_relative '../spec_helper'
require 'chefspec'

ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache')

describe 'rackspace_monitoring::checks' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['rackspace_monitoring_check']) do |node|
      node.set['monitoring']['agent']['id'] = 'rackspace-monitoring-vm.example.com' # fauxhai.local
      node.set['monitoring']['agent']['token'] = '0000000000000000000000000000000000000000000000000000000000000000.000000'
      node.set['monitoring']['enabled'] = false
      node.set['rackspace']['cloud_credentials']['api_key'] = '00000000000000000000000000000000'
      node.set['rackspace']['cloud_credentials']['username'] = 'ChangeMe'

      node.set['monitoring']['remote_http']['example']['target'] = 'example.com'
      node.set['monitoring']['remote_http']['example']['disabled'] = true
    end.converge(described_recipe)
  end
  
  it { expect(chef_run).to create_directory('/etc/rackspace-monitoring-agent.conf.d') }
  it { expect(chef_run).to create_directory('/usr/lib/rackspace-monitoring-agent/plugins') }

  it { expect(chef_run).to render_file('/usr/lib/rackspace-monitoring-agent/plugins/dir_stats.sh') }
  it { expect(chef_run).to render_file('/usr/lib/rackspace-monitoring-agent/plugins/check-mtime.sh') }

  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.cpu.yaml') }
  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.disk.yaml') }
  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.filesystem.yaml') }
  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.load_average.yaml') }
  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/agent.memory.yaml') }
  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/http-example-com.yaml') }
  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/network-eth0.yaml') }

  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/directory-etc.yaml') }
  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.conf.d/file-etc-hosts.yaml') }

end
