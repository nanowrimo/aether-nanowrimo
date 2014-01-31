Aether::Instance.require_user(:instance, 'debian_wheezy')

class Nano::VarnishProxy < Nano::DebianWheezy
  self.default_options = {
    :instance_type => "c3.large", :promote_by => :dns_alias,
    :block_device_mapping => [ { :device_name => '/dev/sdb', :virtual_name => 'ephemeral0' } ]
  }

  after(:promotion) do
    update_dns_records
  end

  # Updates all additional DNS records with either the EC2 hostname (for
  # CNAME records) or public IP address (for A records).
  #
  def update_dns_records
    (options[:additional_dns_records] || []).each do |name|
      notify "updating DNS record #{name}"

      if zone = resolve_dns_zone(name)
        if record = zone.records.find { |record| record.named?(name) && ['A', 'CNAME'].include?(record.type) }
          record.update(:values => [ record.type == 'A' ? public_ip_address : ec2_dns_name ])

          notify "updated record", record 
        else
          notify "FAILED to find existing A or CNAME record"
        end
      else
        notify "FAILED to resolve DNS zone"
      end
    end
  end

  private

  # Finds the zone for the given DNS record.
  #
  def resolve_dns_zone(name)
    if zone = connection.dns.zones.find { |zone| zone.named?(name) }
      zone
    else
      name.include?('.') ? resolve_zone(name[name.index('.') + 1, name.length]) : nil
    end
  end
end
