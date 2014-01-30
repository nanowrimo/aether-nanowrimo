Aether::Instance.require_user(:instance, 'filaments_application')

class Nano::DevFilaments < Nano::FilamentsApplication
  self.type = "dev-filaments"
  self.default_options = { :promote_by => :dns_alias }
end
