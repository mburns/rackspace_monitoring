actions :create, :delete, :disable, :enable, :add, :remove
default_action :create

attribute :id, kind_of: String, name_attribute: true, default: nil
attribute :guid, kind_of: String, default: nil
attribute :token, kind_of: String, required: true, default: nil

attribute :endpoints, kind_of: Array, default: [] # [ IP:Port, ]
attribute :query_endpoints, kind_of: Array, default: [] # [ IP:Port, ]
attribute :snet_region, kind_of: Array, default: nil

attribute :proxy_url, kind_of: String, default: nil
attribute :upgrade, :kind_of => [TrueClass, FalseClass], default: false
attribute :insecure, :kind_of => [TrueClass, FalseClass], default: false

alias_method :monitoring_id, :id
alias_method :monitoring_token, :token
alias_method :proxy, :proxy_url
alias_method :update, :upgrade