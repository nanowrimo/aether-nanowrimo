Aether::Instance.require_user(:instance, 'varnish_proxy')

class Nano::StoreProxy < Nano::VarnishProxy
  self.type = "store-proxy"

  # We reserved a c1.medium for 2014 so we should use it
  self.default_options = { :instance_type => "c1.medium" }
end
