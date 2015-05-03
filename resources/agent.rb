actions :create, :delete, :disable, :enable, :add, :remove
default_action :create

attribute :id, kind_of: String, name_attribute: true, default: nil
attribute :token, kind_of: String, required: true, default: nil

attribute :snet_region, kind_of: [String, Array], default: nil # Service Net endpoints [dfw, ord, lon, syd, hkg, iad]
attribute :endpoints, kind_of: String, regex: /.*(,.*)/, default: nil # IP:Port, comma delimited
attribute :proxy_url, kind_of: String, regex: /.*/, default: nil
attribute :query_endpoints, kind_of: String, default: nil # SRV queries, comma delimited

alias_method :monitoring_id, :id
alias_method :monitoring_token, :token
