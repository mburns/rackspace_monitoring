require 'serverspec'

describe 'Rackspace Monitoring LWRP' do
  describe file('/etc/rackspace-monitoring-agent.cfg') do
    it { should be_a_file }
    it { should be_mode('600') }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
  end

  describe file('/etc/rackspace-monitoring-agent.conf.d') do
    it { should be_directory }
  end

  describe file('/usr/lib/rackspace-monitoring-agent/plugins') do
    it { should be_directory }
    it { should be_mode('755') }
    it { should be_owned_by('root') }
    it { should be_grouped_into('root') }
  end

  ## check_is_installed is not implemented in Specinfra::Command::Ubuntu::Base::Service
  # describe service('rackspace-monitoring-agent') do
  #  it { should be_installed }
  # end

  describe service('rackspace-monitoring-agent') do
    it { should be_enabled }
  end
end
