class Nano::Util < Aether::Instance::Default
  self.type = "util"
  self.default_options = {
    :instance_type => "c1.medium",
    :image_name => "util",
    :availability_zone => 'us-east-1b'
  }
end
