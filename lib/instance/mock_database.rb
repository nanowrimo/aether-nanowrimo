Aether::Instance.require_user(:instance, 'database')

class Nano::MockDatabase < Nano::Database
  self.type = "mock-database"
  self.default_options = Database.default_options.merge(:promote_by => :dns_alias)

  # Mounts the given snapshots as new database volumes.
  #
  def mount_snapshots(snapshots)
    exec!("invoke-rc.d mysql stop", "umount /var/lib/mysql")

    database_meta_disks.each(&:disassemble!)

    attached_volumes.select { |volume| volume.mount_point == "/var/lib/mysql" }.each(&:detach!)
    snapshots.attach_to!(self, :mount => "/var/lib/mysql").wait_for(&:attached?)

    database_meta_disks.each do |md|
      md.assemble!
      md.check(:xfs)
    end

    exec!("mount /var/lib/mysql", "invoke-rc.d mysql start")
  end

  protected

  def database_meta_disks
    meta_disk_devices.select { |device| device.uuid == "e316161b:b4378aed:9243d426:d5fc8224" }
  end
end
