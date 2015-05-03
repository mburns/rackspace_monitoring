require_relative '../spec_helper'

ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache')

describe 'rackspace_monitoring::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
end

describe 'rackspace_monitoring::agent' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it { expect(chef_run).to render_file('/etc/rackspace-monitoring-agent.cfg') }
end

describe 'rackspace_monitoring::package' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it { chef_run.should install_package 'rackspace-monitoring-agent' }
end
