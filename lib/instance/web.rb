class Nano::Web < Aether::Instance::Default
  self.type = "web"
  self.default_options = {
    :instance_type => "c1.medium",
    :image_name => "web",
    :configure_by => nil
  }
end
