class Nano::Database < Aether::Instance::Default
  include Aether::InstanceHelpers::MetaDisk

  self.type = "database"
  self.default_options = {
    :elastic_ip => "",
    :instance_type => "m2.4xlarge",
    :image_name => "database-master",
    :availability_zone => "us-east-1b",
    :promote_by => :elastic_ip,
    :configure_by => nil
  }

  before(:demotion) do
    exec!("invoke-rc.d mysql stop", "umount /var/lib/mysql", "umount /mnt/mysqld")
    meta_disk_devices.each(&:disassemble!)
    attached_volumes.each(&:detach!)
  end

  after(:promotion) do
    volumes.wait_for { |volume| volume.available? }
    attach_volumes!
    volumes.wait_for { |volume| volume.attached? && file_exists?(volume.device) }

    meta_disk_devices.each(&:assemble!)
    meta_disk_devices.each { |md| md.check(:xfs) }

    exec!("ln -nfs #{mysql_sized_config_path} /etc/mysql/my-sized.cnf")
    exec!("mount /var/lib/mysql", "mount /mnt/mysqld", "invoke-rc.d mysql start")
  end

  def mysql_sized_config_path
    "/etc/mysql/my-#{info.instanceType.sub(/^[^\.]+\./, '')}.cnf"
  end
end
