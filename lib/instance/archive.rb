Aether::Instance.require_user(:instance, 'debian_wheezy')

class Nano::Archive < Nano::DebianWheezy
  self.type = "archive"
  self.default_options = {
    :instance_type => "c3.large",
    :block_device_mapping => [ { :device_name => '/dev/sdb', :virtual_name => 'ephemeral0' } ],
    :promote_by => :dns_alias,
    :availability_zone => 'us-east-1b',
  }

  before(:demotion) do
    exec!(<<-end_exec)
      invoke-rc.d varnish stop
      invoke-rc.d nginx stop
      grep '/dev/loop' /proc/mounts | while read x dir x; do umount $dir; done
      umount /var/www-archive
    end_exec

    attached_volumes.each(&:detach!)
  end

  after(:promotion) do
    volumes.wait_for { |volume| volume.available? }
    attach_volumes!
    volumes.wait_for { |volume| volume.attached? && file_exists?(volume.device) }

    exec!(<<-end_exec)
      mkdir -p /var/www/archive /var/www-archive
      mount /dev/xvdh /var/www-archive
      /var/www-archive/mount_all.sh
    end_exec
  end
end
