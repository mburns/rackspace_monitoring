require_relative '../spec_helper'
require 'chefspec'

ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache')

describe 'rackspace_monitoring::agent' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['rackspace_monitoring_agent']) do |node|
      node.set['monitoring']['agent']['id'] = 'rackspace-monitoring-vm.example.com' # fauxhai.local
      node.set['monitoring']['agent']['token'] = '0000000000000000000000000000000000000000000000000000000000000000.000000'
      node.set['monitoring']['enabled'] = false
      node.set['rackspace']['cloud_credentials']['api_key'] = '00000000000000000000000000000000'
      node.set['rackspace']['cloud_credentials']['username'] = 'ChangeMe'
    end.converge(described_recipe)
  end

  it { expect(chef_run).to upgrade_package('rackspace-monitoring-agent') }
  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.cfg') }
  it { expect(chef_run).to disable_service('rackspace-monitoring-agent') }
end
