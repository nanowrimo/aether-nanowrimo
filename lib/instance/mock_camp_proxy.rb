class Nano::MockCampProxy < Aether::Instance::Default
  self.type = "mock-camp-proxy"
  self.default_options = { :instance_type => "c1.medium", :promote_by => :dns_alias }
end
