Aether::Instance.require_user(:instance, 'varnish_proxy')

class Nano::Proxy < Nano::VarnishProxy
  self.type = "proxy"
  self.default_options = {
    :additional_dns_records => [ "lettersandlight.org" ],
  }
end
