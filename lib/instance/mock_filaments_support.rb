class Nano::MockFilamentsSupport < Aether::Instance::Default
  self.type = "mock-filaments-support"
  self.default_options = {:instance_type => "m1.large", :promote_by => :dns_alias}
end
