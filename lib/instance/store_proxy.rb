Aether::Instance.require_user(:instance, 'varnish_proxy')

class Nano::StoreProxy < Nano::VarnishProxy
  self.type = "store-proxy"
  self.default_options = {
    :ssl_certificate_path => "~/.aether/nanowrimo.org.chained.crt",
    :ssl_certificate_key_path => "~/.aether/nanowrimo.org.key",
  }
end
