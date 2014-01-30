Aether::Instance.require_user(:instance, 'varnish_proxy')

class Nano::FilamentsProxy < Nano::VarnishProxy
  self.type = "filaments-proxy"
  self.default_options = {
    :ssl_certificate_path => "~/.aether/nanowrimo.org.chained.crt",
    :ssl_certificate_key_path => "~/.aether/nanowrimo.org.key",
    :additional_dns_records => [ "nanowrimo.org" ],
  }
end
