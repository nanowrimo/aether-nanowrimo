require 'base64'
require 'erb'

class Nano::DebianWheezy < Aether::Instance::Default
  self.type = "default"

  # Debian AMIs are listed at https://wiki.debian.org/Cloud/AmazonEC2Image/Wheezy
  self.default_options = {
    :image_id => "ami-b7c8d5de",
    :user_data => proc { Base64.encode64(Aether::Instance.user_file(:cloud_init, 'debian_wheezy_puppet.yaml').read) }
  }
end
