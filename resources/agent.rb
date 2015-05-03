actions :create, :delete, :disable, :enable
default_action :create

attribute :id, :kind_of => String, :name_attribute => true
attribute :token, kind_of: String, :required => true

attribute :snet_region, kind_of: String # Service Net endpoints [dfw, ord, lon, syd, hkg, iad]
attribute :endpoints, kind_of: [String, Array] # IP:Port, comma delimited
attribute :proxy_url, kind_of: [String, NilClass], :regex [ /^(https:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/ ]
attribute :query_endpoints, kind_of: [String, NilClass] # SRV queries, comma delimited
