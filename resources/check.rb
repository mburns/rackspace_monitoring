actions :create, :delete, :add, :remove
default_action :create

attribute :label, kind_of: String, name_attribute: true
attribute :type, kind_of: String

attribute :monitoring_zones, kind_of: Array
attribute :period, kind_of: Integer, default: nil
attribute :timeout, kind_of: Integer, default: nil
attribute :alarm, kind_of: [TrueClass, FalseClass], default: false

# remote-related options
attribute :target, kind_of: String, default: nil
attribute :target_alias, kind_of: String, default: nil
attribute :target_hostname, kind_of: String, default: nil
attribute :target_resolver, kind_of: String, default: nil

# source for agent check.yaml template, allows custom checks and fine-grained alert logic
attribute :yaml_cookbook, kind_of: String, default: nil
attribute :yaml_source, kind_of: String, default: nil

# custom scripts (bash, python, ruby, etc) to be parsed by an agent check
attribute :source, kind_of: String, default: nil
attribute :file, kind_of: String, default: nil

attribute :info, kind_of: Hash

alias_method :alias, :target_alias
alias_method :hostname, :target_hostname
alias_method :resolver, :target_resolver
alias_method :file_uri, :source
