Aether::Instance.require_user(:instance, 'varnish_proxy')

class Nano::FilamentsProxy < Nano::VarnishProxy
  self.type = "filaments-proxy"
  self.default_options = {
    :additional_dns_records => [ "nanowrimo.org" ],
  }
end
