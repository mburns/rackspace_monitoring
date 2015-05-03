#
# Copyright 2015, Michael Burns
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'serverspec'
set :backend, :exec

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
