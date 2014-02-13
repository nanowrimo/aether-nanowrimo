class Nano::Cache < Aether::Instance::Default
  self.type = "cache"
  self.default_options = {
    :instance_type => "m1.large",
    :image_name => "cache",
    :availability_zone => 'us-east-1b',
  }
end
