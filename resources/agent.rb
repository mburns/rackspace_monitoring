actions :create, :delete, :disable, :enable, :add, :remove
default_action :create

attribute :id, kind_of: String, name_attribute: true, default: nil
attribute :token, kind_of: String, required: true, default: nil

attribute :endpoints, kind_of: [Array, String] # [ IP:Port, ]
attribute :proxy_url, kind_of: String, regex: /.*/, default: nil

alias_method :monitoring_id, :id
alias_method :monitoring_token, :token
