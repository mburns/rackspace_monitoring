require_relative '../spec_helper'

ChefSpec::SoloRunner.new(file_cache_path: '/var/chef/cache')

describe 'rackspace_monitoring::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
end
