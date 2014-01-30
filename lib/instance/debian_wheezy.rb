require 'base64'
require 'erb'

class Nano::DebianWheezy < Aether::Instance::Default
  self.type = "default"

  # Debian AMIs are listed at https://wiki.debian.org/Cloud/AmazonEC2Image/Wheezy
  self.default_options = {
    :image_id => "ami-0da18864",
    :user_data => proc { Base64.encode64(Aether::Instance.user_file(:cloud_init, 'debian_wheezy_puppet.yaml').read) }
  }

  after(:run) do
    wait_for("running state") { running? }

    # Create the DNS record early for cloud-init processes
    create_dns_alias(name)

    wait_for("ssh access") { ssh? }
    wait_for("cloud-init to install puppet") { file_exists?('/var/lib/puppet') }
  end
end
