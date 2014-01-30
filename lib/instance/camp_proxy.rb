Aether::Instance.require_user(:instance, 'varnish_proxy')

class Nano::CampProxy < Nano::VarnishProxy
  self.type = "camp-proxy"
  self.default_options = {
    :ssl_certificate_path => "~/.aether/campnanowrimo.org.chained.crt",
    :ssl_certificate_key_path => "~/.aether/campnanowrimo.org.key",
    :additional_dns_records => [ "campnanowrimo.org" ],
  }
end
