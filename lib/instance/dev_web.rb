class Nano::DevWeb < Aether::Instance::Default
  self.type = "dev-web"
  self.default_options = {
    :image_name => "base",
    :instance_type => "c1.medium"
  }
end
