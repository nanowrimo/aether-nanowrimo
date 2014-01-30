class Nano::DevDatabase < Aether::Instance::Default
  include Aether::InstanceHelpers::MetaDisk

  self.type = "dev-database"
  self.default_options = {
    :instance_type => "m1.large",
    :image_name => "dev-master-db",
    :availability_zone => 'us-east-1b',
    :promote_by => :dns_alias
  }

  before(:demotion) do
    exec!("invoke-rc.d mysql stop", "umount /var/lib/mysql")
    exec!("invoke-rc.d nfs-kernel-server stop", "umount /var/lib/drupal")

    meta_disk_devices.each(&:disassemble!)
    exec!("vgchange -a n")

    attached_volumes.each(&:detach!)
  end

  after(:promotion) do
    volumes.wait_for { |volume| volume.available? }
    attach_volumes!
    volumes.wait_for { |volume| volume.attached? && file_exists?(volume.device) }

    exec!("vgchange -a y", "fsck.jfs /dev/dev-drupal/vol0")

    meta_disk_devices.each(&:assemble!)
    exec!("fsck.xfs /dev/md/0")

    exec!("mount /var/lib/drupal", "invoke-rc.d nfs-kernel-server restart")
    exec!("mount /var/lib/mysql", "invoke-rc.d mysql start")
  end
end
