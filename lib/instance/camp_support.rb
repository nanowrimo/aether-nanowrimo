Aether::Instance.require_user(:instance, 'debian_wheezy')

class Nano::CampSupport < Nano::DebianWheezy
  self.type = "camp-support"
  self.default_options = {
    :instance_type => "m1.large",
    :promote_by => :dns_alias,
    :block_device_mapping => [ { :device_name => '/dev/sdb', :virtual_name => 'ephemeral0' } ],
  }
end
