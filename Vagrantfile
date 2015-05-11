# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.7.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'rackspace-monitoring-cookbook'

  #   $ vagrant plugin install vagrant-cachier
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.auto_detect = true
    config.cache.scope = :machine
    config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end

  #   $ vagrant plugin install vagrant-omnibus
  if Vagrant.has_plugin?('vagrant-omnibus')
    config.omnibus.chef_version = '11.8.2'
    config.omnibus.cache_packages = true
  end

  # If this value is a shorthand to a box in Vagrant Cloud then
  # config.vm.box_url doesn't need to be specified.
  config.vm.box = 'chef/ubuntu-14.04'

  config.vm.network :private_network, type: 'dhcp'

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.run_list = ['recipe[rackspace_monitoring::agent]', 'recipe[rackspace_monitoring::checks]']
    chef.json = {
      'monitoring' => {
        'agent' => {
          'token' => '0000000000000000000000000000000000000000000000000000000000000000.000000'
        },
        'enabled' => false
      },
      'rackspace' => {
        'cloud_credentials' => {
          'username' => 'ChangeMe',
          'api_key' => '00000000000000000000000000000000'
        }
      }
    }
  end
end
