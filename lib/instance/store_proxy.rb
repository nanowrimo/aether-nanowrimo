Aether::Instance.require_user(:instance, 'varnish_proxy')

class Nano::StoreProxy < Nano::VarnishProxy
  self.type = "store-proxy"
end
