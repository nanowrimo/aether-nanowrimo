Aether::Instance.require_user(:instance, 'varnish_proxy')

class Nano::MockFilamentsProxy < Nano::VarnishProxy
  self.type = "mock-filaments-proxy"
end
