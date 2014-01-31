Aether::Instance.require_user(:instance, 'varnish_proxy')

class Nano::CampProxy < Nano::VarnishProxy
  self.type = "camp-proxy"
  self.default_options = {
    :additional_dns_records => [ "campnanowrimo.org" ],
  }
end
