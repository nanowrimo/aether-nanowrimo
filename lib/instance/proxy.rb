Aether::Instance.require_user(:instance, 'varnish_proxy')

class Nano::Proxy < Nano::VarnishProxy
  self.type = "proxy"
  self.default_options = {
    :ssl_certificate_path => "~/.aether/nanowrimo.org.chained.crt",
    :ssl_certificate_key_path => "~/.aether/nanowrimo.org.key",
    :additional_dns_records => [ "lettersandlight.org" ],
  }
end
