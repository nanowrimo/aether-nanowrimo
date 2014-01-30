Aether::Instance.require_user(:instance, 'debian_wheezy')

class Nano::Logger < Nano::DebianWheezy
  self.type = "logger"
  self.default_options = {
    :instance_type => "c3.large",
    :block_device_mapping => [ { :device_name => '/dev/sdb', :virtual_name => 'ephemeral0' } ],
    :promote_by => :elastic_ip,
    :availability_zone => 'us-east-1b',
  }

  # 1. Stop all processes that might be accessing mounts
  # 2. Unmount all LVM-volume mount points
  # 3. Disassemble LVM logical volumes and volume groups
  # 4. Detach volumes
  before(:demotion) do
    exec!(<<-end_exec)
      invoke-rc.d postfix stop
      invoke-rc.d syslog-ng stop
      killall munin-cron && true
      killall munin-update && true
      umount /var/log
      umount /var/lib/munin
      lvchange -an /dev/mapper/munin-vol0 /dev/mapper/logs-vol0
      vgchange -an munin logs
    end_exec

    attached_volumes.each(&:detach!)
  end

  # (The inverse of above)
  # 1. Attach volumes
  # 2. Assemble LVM volume groups and logical volumes
  # 3. Mount LVM-volumes
  # 4. Restart processes
  after(:promotion) do
    volumes.wait_for("availability") { |volume| volume.available? }
    attach_volumes!
    volumes.wait_for("attachment") { |volume| volume.attached? && file_exists?(volume.device) }

    exec!(<<-end_exec)
      invoke-rc.d postfix stop
      invoke-rc.d syslog-ng stop
      vgchange -ay munin logs
      lvchange -ay /dev/mapper/munin-vol0 /dev/mapper/logs-vol0
      mount /dev/mapper/munin-vol0 /var/lib/munin
      mount /dev/mapper/logs-vol0 /var/log
      invoke-rc.d postfix start
      invoke-rc.d syslog-ng start
    end_exec
  end
end
