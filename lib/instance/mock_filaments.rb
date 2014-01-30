Aether::Instance.require_user(:instance, 'debian_wheezy')

class Nano::MockFilaments < Nano::DebianWheezy
  self.type = "mock-filaments"
  self.default_options = {
    :instance_type => "c1.medium",
    :block_device_mapping => [ { :device_name => '/dev/sdb', :virtual_name => 'ephemeral0' } ],
  }
end
