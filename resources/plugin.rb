actions :create, :delete, :add, :remove
default_action :create

attribute :name, kind_of: String, name_attribute: true
attribute :source, kind_of: String, default: nil
attribute :file, kind_of: String, default: nil
attribute :cookbook, kind_of: String, default: nil
attribute :info, kind_of: Hash
