Aether::Instance.require_user(:instance, 'debian_wheezy')

class Nano::VarnishProxy < Nano::DebianWheezy
  self.default_options = {
    :instance_type => "c3.large", :promote_by => :dns_alias,
    :block_device_mapping => [ { :device_name => '/dev/sdb', :virtual_name => 'ephemeral0' } ]
  }

  after(:launch) do
    wait_for { running? && ssh? }
    upload_ssl_certificate
  end

  after(:promotion) do
    update_dns_records
  end

  def ssl_certificate_path
    options[:ssl_certificate_path] || @connection.options[:ssl_certificate_path]
  end

  def ssl_certificate_key_path
    options[:ssl_certificate_key_path] || @connection.options[:ssl_certificate_key_path]
  end

  # Upload the configured SSL certificate and key to /etc/ssl/private.
  # Derived classes must provide the `ssl_certificate_path` and
  # `ssl_certificate_key_path` options.
  #
  def upload_ssl_certificate
    cert = File.expand_path(ssl_certificate_path)
    key = File.expand_path(ssl_certificate_key_path)

    if File.exists?(cert) && File.exists?(key)
      notify "uploading SSL certificate and key files", cert, key

      upload_to_directory!("/etc/ssl/private", cert => 0400, key => 0400)
    else
      notify "WARNING: certificate file `#{cert}' doesn't exist. SSL offloading won't function until the certificate is uploaded." unless File.exists?(cert)
      notify "WARNING: certificate key file `#{key}' doesn't exist. SSL offloading won't function until the key is uploaded." unless File.exists?(key)
    end
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
