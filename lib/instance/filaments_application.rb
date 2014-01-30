Aether::Instance.require_user(:instance, 'debian_wheezy')

class Nano::FilamentsApplication < Nano::DebianWheezy
  self.default_options = {
    :instance_type => "c3.large",
    :block_device_mapping => [ { :device_name => '/dev/sdb', :virtual_name => 'ephemeral0' } ]
  }
end
