class Nano::DatabaseSlave < Aether::Instance::Default
  include Aether::InstanceHelpers::MetaDisk

  self.type = "database-slave"
  self.default_options = {
    :instance_type => "m2.4xlarge",
    :image_name => "database-slave",
    :availability_zone => 'us-east-1b',
    :configure_by => nil
  }
end
